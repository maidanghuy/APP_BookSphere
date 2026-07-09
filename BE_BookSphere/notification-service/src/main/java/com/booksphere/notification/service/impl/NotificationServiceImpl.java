package com.booksphere.notification.service.impl;

import com.booksphere.notification.config.UserContext;
import com.booksphere.notification.dto.request.NotificationCreateRequest;
import com.booksphere.notification.dto.request.NotificationSearchRequest;
import com.booksphere.notification.dto.response.NotificationCreateResult;
import com.booksphere.notification.dto.response.NotificationResponse;
import com.booksphere.notification.dto.response.PageResponse;
import com.booksphere.notification.dto.response.ReadAllResponse;
import com.booksphere.notification.entity.Notification;
import com.booksphere.notification.entity.enums.NotificationType;
import com.booksphere.notification.exception.BusinessException;
import com.booksphere.notification.mapper.NotificationMapper;
import com.booksphere.notification.repository.NotificationRepository;
import com.booksphere.notification.service.NotificationService;
import java.time.LocalDateTime;
import java.util.Set;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NotificationServiceImpl implements NotificationService {

    private static final Set<String> ALLOWED_SORT_FIELDS = Set.of("id", "createdAt", "readAt", "type", "title");

    private final NotificationRepository notificationRepository;

    public NotificationServiceImpl(NotificationRepository notificationRepository) {
        this.notificationRepository = notificationRepository;
    }

    @Override
    @Transactional
    public NotificationCreateResult createNotificationInternal(NotificationCreateRequest request) {
        String normalizedType = parseNotificationType(request.getType()).name();
        String eventKey = request.getEventKey().trim();

        return notificationRepository.findByEventKey(eventKey)
                .map(existing -> new NotificationCreateResult(NotificationMapper.toResponse(existing), false))
                .orElseGet(() -> createNewNotification(request, normalizedType, eventKey));
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<NotificationResponse> searchMyNotifications(
            NotificationSearchRequest request,
            UserContext userContext
    ) {
        request.setUserId(userContext.userId());
        validateTypeFilter(request.getType());
        return toPageResponse(search(request));
    }

    @Override
    @Transactional(readOnly = true)
    public PageResponse<NotificationResponse> searchNotifications(
            NotificationSearchRequest request,
            UserContext userContext
    ) {
        Long effectiveUserId = resolveSearchUserId(request.getUserId(), userContext);
        request.setUserId(effectiveUserId);
        validateTypeFilter(request.getType());
        return toPageResponse(search(request));
    }

    @Override
    @Transactional(readOnly = true)
    public NotificationResponse getNotificationById(Long notificationId, UserContext userContext) {
        Notification notification = getNotificationOrThrow(notificationId);
        requireNotificationAccess(notification, userContext);
        return NotificationMapper.toResponse(notification);
    }

    @Override
    @Transactional
    public NotificationResponse markAsRead(Long notificationId, UserContext userContext) {
        Notification notification = getNotificationOrThrow(notificationId);
        requireNotificationWriteAccess(notification, userContext);

        if (!Boolean.TRUE.equals(notification.getIsRead())) {
            notification.setIsRead(true);
            notification.setReadAt(LocalDateTime.now());
            notificationRepository.save(notification);
        }

        return NotificationMapper.toResponse(notification);
    }

    @Override
    @Transactional
    public ReadAllResponse markAllAsRead(UserContext userContext) {
        int updatedCount = notificationRepository.markAllAsReadByUserId(
                userContext.userId(),
                LocalDateTime.now()
        );
        return new ReadAllResponse(updatedCount);
    }

    private NotificationCreateResult createNewNotification(
            NotificationCreateRequest request,
            String normalizedType,
            String eventKey
    ) {
        Notification notification = new Notification();
        notification.setUserId(request.getUserId());
        notification.setTitle(request.getTitle().trim());
        notification.setContent(request.getContent());
        notification.setType(normalizedType);
        notification.setReferenceId(request.getReferenceId());
        notification.setEventKey(eventKey);
        notification.setIsRead(false);

        try {
            Notification saved = notificationRepository.save(notification);
            return new NotificationCreateResult(NotificationMapper.toResponse(saved), true);
        } catch (DataIntegrityViolationException exception) {
            Notification existing = notificationRepository.findByEventKey(eventKey)
                    .orElseThrow(() -> new BusinessException(
                            "INTERNAL_SERVER_ERROR",
                            "Failed to resolve duplicate notification.",
                            HttpStatus.INTERNAL_SERVER_ERROR
                    ));
            return new NotificationCreateResult(NotificationMapper.toResponse(existing), false);
        }
    }

    private Page<Notification> search(NotificationSearchRequest request) {
        Pageable pageable = buildPageable(request);
        String normalizedType = normalizeType(request.getType());
        return notificationRepository.search(
                request.getUserId(),
                normalizedType,
                request.getIsRead(),
                pageable
        );
    }

    private PageResponse<NotificationResponse> toPageResponse(Page<Notification> notificationPage) {
        PageResponse<NotificationResponse> response = new PageResponse<>();
        response.setContent(notificationPage.getContent().stream().map(NotificationMapper::toResponse).toList());
        response.setPage(notificationPage.getNumber());
        response.setSize(notificationPage.getSize());
        response.setTotalElements(notificationPage.getTotalElements());
        response.setTotalPages(notificationPage.getTotalPages());
        return response;
    }

    private Notification getNotificationOrThrow(Long notificationId) {
        return notificationRepository.findById(notificationId)
                .orElseThrow(() -> new BusinessException(
                        "NOTIFICATION_NOT_FOUND",
                        "Notification not found.",
                        HttpStatus.NOT_FOUND
                ));
    }

    private void requireNotificationAccess(Notification notification, UserContext userContext) {
        if (userContext.isMemberOnly() && !notification.getUserId().equals(userContext.userId())) {
            throw new BusinessException(
                    "NOTIFICATION_ACCESS_DENIED",
                    "Insufficient permissions.",
                    HttpStatus.FORBIDDEN
            );
        }
    }

    private void requireNotificationWriteAccess(Notification notification, UserContext userContext) {
        if (userContext.isMemberOnly() && !notification.getUserId().equals(userContext.userId())) {
            throw new BusinessException(
                    "NOTIFICATION_ACCESS_DENIED",
                    "Insufficient permissions.",
                    HttpStatus.FORBIDDEN
            );
        }
    }

    private Long resolveSearchUserId(Long requestedUserId, UserContext userContext) {
        if (userContext.isMemberOnly()) {
            if (requestedUserId != null && !requestedUserId.equals(userContext.userId())) {
                throw new BusinessException(
                        "NOTIFICATION_ACCESS_DENIED",
                        "Insufficient permissions.",
                        HttpStatus.FORBIDDEN
                );
            }
            return userContext.userId();
        }
        return requestedUserId;
    }

    private void validateTypeFilter(String type) {
        if (type == null || type.isBlank()) {
            return;
        }
        parseNotificationType(type);
    }

    private String normalizeType(String type) {
        if (type == null || type.isBlank()) {
            return null;
        }
        return parseNotificationType(type).name();
    }

    private NotificationType parseNotificationType(String type) {
        try {
            return NotificationType.valueOf(type.trim().toUpperCase());
        } catch (IllegalArgumentException exception) {
            throw new BusinessException(
                    "NOTIFICATION_INVALID_TYPE",
                    "Invalid notification type.",
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    private Pageable buildPageable(NotificationSearchRequest request) {
        String sortField = ALLOWED_SORT_FIELDS.contains(request.getSortBy()) ? request.getSortBy() : "createdAt";
        Sort.Direction direction = "asc".equalsIgnoreCase(request.getSortDir())
                ? Sort.Direction.ASC
                : Sort.Direction.DESC;
        int page = Math.max(request.getPage(), 0);
        int size = request.getSize() > 0 ? request.getSize() : 10;
        return PageRequest.of(page, size, Sort.by(direction, sortField));
    }
}
