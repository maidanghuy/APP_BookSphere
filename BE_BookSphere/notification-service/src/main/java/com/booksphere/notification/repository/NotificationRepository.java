package com.booksphere.notification.repository;

import com.booksphere.notification.entity.Notification;
import java.time.LocalDateTime;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    Optional<Notification> findByEventKey(String eventKey);

    boolean existsByEventKey(String eventKey);

    Page<Notification> findByUserId(Long userId, Pageable pageable);

    Page<Notification> findByUserIdAndIsRead(Long userId, Boolean isRead, Pageable pageable);

    Page<Notification> findByUserIdAndType(Long userId, String type, Pageable pageable);

    long countByUserIdAndIsReadFalse(Long userId);

    @Query("""
            SELECT n FROM Notification n
            WHERE (:userId IS NULL OR n.userId = :userId)
              AND (:type IS NULL OR n.type = :type)
              AND (:isRead IS NULL OR n.isRead = :isRead)
            """)
    Page<Notification> search(
            @Param("userId") Long userId,
            @Param("type") String type,
            @Param("isRead") Boolean isRead,
            Pageable pageable
    );

    @Modifying
    @Query("""
            UPDATE Notification n
            SET n.isRead = true,
                n.readAt = :readAt
            WHERE n.userId = :userId
              AND n.isRead = false
            """)
    int markAllAsReadByUserId(@Param("userId") Long userId, @Param("readAt") LocalDateTime readAt);
}
