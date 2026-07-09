package com.booksphere.borrow.entity;

import com.booksphere.borrow.entity.enums.SagaStatus;
import com.booksphere.borrow.entity.enums.SagaTransactionType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;

@Entity
@Table(name = "saga_logs")
public class SagaLog {

    private static final int MAX_ERROR_MESSAGE_BYTES = 240;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "saga_id", nullable = false, unique = true, length = 100)
    private String sagaId;

    @Column(name = "borrow_id")
    private Long borrowId;

    @Enumerated(EnumType.STRING)
    @Column(name = "transaction_type", length = 50)
    private SagaTransactionType transactionType;

    @Column(name = "current_step", length = 100)
    private String currentStep;

    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private SagaStatus status;

    @Lob
    @Column(name = "compensation_action")
    private String compensationAction;

    @Lob
    @Column(name = "error_message")
    private String errorMessage;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    protected SagaLog() {
    }

    public SagaLog(String sagaId, SagaTransactionType transactionType, String currentStep, SagaStatus status) {
        this.sagaId = sagaId;
        this.transactionType = transactionType;
        this.currentStep = currentStep;
        this.status = status;
    }

    @PrePersist
    void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public String getSagaId() {
        return sagaId;
    }

    public void setSagaId(String sagaId) {
        this.sagaId = sagaId;
    }

    public Long getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(Long borrowId) {
        this.borrowId = borrowId;
    }

    public SagaTransactionType getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(SagaTransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public String getCurrentStep() {
        return currentStep;
    }

    public void setCurrentStep(String currentStep) {
        this.currentStep = currentStep;
    }

    public SagaStatus getStatus() {
        return status;
    }

    public void setStatus(SagaStatus status) {
        this.status = status;
    }

    public String getCompensationAction() {
        return compensationAction;
    }

    public void setCompensationAction(String compensationAction) {
        this.compensationAction = compensationAction;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = truncateUtf8(errorMessage);
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    private static String truncateUtf8(String value) {
        if (value == null || value.getBytes(StandardCharsets.UTF_8).length <= MAX_ERROR_MESSAGE_BYTES) {
            return value;
        }

        StringBuilder truncated = new StringBuilder();
        int byteCount = 0;
        int byteLimit = MAX_ERROR_MESSAGE_BYTES - 3;
        for (int index = 0; index < value.length(); ) {
            int codePoint = value.codePointAt(index);
            String character = new String(Character.toChars(codePoint));
            int characterBytes = character.getBytes(StandardCharsets.UTF_8).length;
            if (byteCount + characterBytes > byteLimit) {
                break;
            }

            truncated.append(character);
            byteCount += characterBytes;
            index += Character.charCount(codePoint);
        }

        return truncated + "...";
    }
}
