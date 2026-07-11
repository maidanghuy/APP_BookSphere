package com.booksphere.auth.security;

import com.booksphere.auth.dto.response.ApiResponse;
import com.booksphere.auth.exception.ErrorResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtService jwtService;
    private final ObjectMapper objectMapper;

    public JwtAuthenticationFilter(JwtService jwtService, ObjectMapper objectMapper) {
        this.jwtService = jwtService;
        this.objectMapper = objectMapper;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        String authorizationHeader = request.getHeader(HttpHeaders.AUTHORIZATION);

        if (authorizationHeader == null || !authorizationHeader.startsWith(BEARER_PREFIX)) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authorizationHeader.substring(BEARER_PREFIX.length());

        try {
            Claims claims = jwtService.parseAccessToken(token);
            String username = requiredClaim(claims, "username");
            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                    username,
                    null,
                    authorities(claims.get("roles"))
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            filterChain.doFilter(request, response);
        } catch (ExpiredJwtException exception) {
            SecurityContextHolder.clearContext();
            writeUnauthorizedResponse(
                    request,
                    response,
                    "AUTH_TOKEN_EXPIRED",
                    "Access token is expired or invalid."
            );
        } catch (JwtException | IllegalArgumentException exception) {
            SecurityContextHolder.clearContext();
            writeUnauthorizedResponse(
                    request,
                    response,
                    "AUTH_TOKEN_INVALID",
                    "Access token is expired or invalid."
            );
        }
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        String method = request.getMethod();

        if (isMethod(HttpMethod.POST, method)
                && ("/api/auth/register".equals(path)
                || "/api/auth/login".equals(path)
                || "/api/auth/refresh".equals(path)
                || "/api/auth/logout".equals(path))) {
            return true;
        }

        return (isMethod(HttpMethod.GET, method) && "/internal/users".equals(path))
                || (isMethod(HttpMethod.GET, method) && path.startsWith("/internal/users/"))
                || (isMethod(HttpMethod.GET, method) && "/actuator/health".equals(path))
                || "/swagger-ui.html".equals(path)
                || path.startsWith("/swagger-ui/")
                || "/v3/api-docs".equals(path)
                || path.startsWith("/v3/api-docs/")
                || path.startsWith("/swagger-resources/")
                || path.startsWith("/webjars/");
    }

    private boolean isMethod(HttpMethod expectedMethod, String actualMethod) {
        return expectedMethod.name().equals(actualMethod);
    }

    private String requiredClaim(Claims claims, String claimName) {
        Object value = claims.get(claimName);
        if (value == null || value.toString().isBlank()) {
            throw new IllegalArgumentException("Missing JWT claim: " + claimName);
        }

        return value.toString();
    }

    private List<SimpleGrantedAuthority> authorities(Object rolesClaim) {
        if (rolesClaim instanceof Collection<?> roles) {
            return roles.stream()
                    .map(String::valueOf)
                    .filter(role -> !role.isBlank())
                    .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                    .toList();
        }

        if (rolesClaim == null || rolesClaim.toString().isBlank()) {
            throw new IllegalArgumentException("Missing JWT claim: roles");
        }

        return List.of(new SimpleGrantedAuthority("ROLE_" + rolesClaim));
    }

    private void writeUnauthorizedResponse(
            HttpServletRequest request,
            HttpServletResponse response,
            String errorCode,
            String errorMessage
    ) throws IOException {
        ApiResponse<Void> body = ApiResponse.failure(
                "Unauthorized.",
                List.of(new ErrorResponse(errorCode, errorMessage)),
                request.getRequestURI(),
                HttpStatus.UNAUTHORIZED.value()
        );

        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        objectMapper.writeValue(response.getOutputStream(), body);
    }
}
