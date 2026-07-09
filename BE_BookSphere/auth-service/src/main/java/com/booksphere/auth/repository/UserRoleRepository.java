package com.booksphere.auth.repository;

import com.booksphere.auth.entity.UserRole;
import com.booksphere.auth.entity.UserRoleId;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRoleRepository extends JpaRepository<UserRole, UserRoleId> {

    List<UserRole> findByUser_Id(Long userId);
}
