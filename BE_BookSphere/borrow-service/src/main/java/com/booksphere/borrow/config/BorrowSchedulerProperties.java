package com.booksphere.borrow.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "booksphere.borrow")
public class BorrowSchedulerProperties {

    private Scheduler overdueScheduler = new Scheduler(true, 60000);
    private DueSoon dueSoon = new DueSoon(true, 24, 300000);

    public Scheduler getOverdueScheduler() {
        return overdueScheduler;
    }

    public void setOverdueScheduler(Scheduler overdueScheduler) {
        this.overdueScheduler = overdueScheduler;
    }

    public DueSoon getDueSoon() {
        return dueSoon;
    }

    public void setDueSoon(DueSoon dueSoon) {
        this.dueSoon = dueSoon;
    }

    public static class Scheduler {

        private boolean enabled;
        private long fixedDelayMs;

        public Scheduler() {
        }

        public Scheduler(boolean enabled, long fixedDelayMs) {
            this.enabled = enabled;
            this.fixedDelayMs = fixedDelayMs;
        }

        public boolean isEnabled() {
            return enabled;
        }

        public void setEnabled(boolean enabled) {
            this.enabled = enabled;
        }

        public long getFixedDelayMs() {
            return fixedDelayMs;
        }

        public void setFixedDelayMs(long fixedDelayMs) {
            this.fixedDelayMs = fixedDelayMs;
        }
    }

    public static class DueSoon extends Scheduler {

        private long windowHours;

        public DueSoon() {
        }

        public DueSoon(boolean enabled, long windowHours, long fixedDelayMs) {
            super(enabled, fixedDelayMs);
            this.windowHours = windowHours;
        }

        public long getWindowHours() {
            return windowHours;
        }

        public void setWindowHours(long windowHours) {
            this.windowHours = windowHours;
        }
    }
}
