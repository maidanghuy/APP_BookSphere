package com.booksphere.fine.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "Internal fine create result")
public class FineCreateResult {

    @Schema(description = "Fine response")
    private FineResponse fine;
    @Schema(description = "Whether a new fine was created", example = "true")
    private boolean created;

    public FineCreateResult(FineResponse fine, boolean created) {
        this.fine = fine;
        this.created = created;
    }

    public FineResponse getFine() {
        return fine;
    }

    public void setFine(FineResponse fine) {
        this.fine = fine;
    }

    public boolean isCreated() {
        return created;
    }

    public void setCreated(boolean created) {
        this.created = created;
    }
}
