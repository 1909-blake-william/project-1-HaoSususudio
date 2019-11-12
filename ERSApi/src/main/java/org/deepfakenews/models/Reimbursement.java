package org.deepfakenews.models;

import java.sql.Timestamp;

public class Reimbursement {
  private int reimbId;
  private Double amount;
  private Timestamp submittedTime;
  private Timestamp resolvedTime;
  private String description;
  private Integer authorId;
  private Integer resolverId;
  private String status;
  private String type;

  public Reimbursement() {
    super();
    // TODO Auto-generated constructor stub
  }

  public Reimbursement(int reimbId, double amount, Timestamp submittedTime, Timestamp resolvedTime,
      String description, int authorId, int resolverId, String status, String type) {
    super();
    this.reimbId = reimbId;
    this.amount = amount;
    this.submittedTime = submittedTime;
    this.resolvedTime = resolvedTime;
    this.description = description;
    this.authorId = authorId;
    this.resolverId = resolverId;
    this.status = status;
    this.type = type;
  }

  public int getReimbId() {
    return reimbId;
  }

  public void setReimbId(int reimbId) {
    this.reimbId = reimbId;
  }

  public double getAmount() {
    return amount;
  }

  public void setAmount(double amount) {
    this.amount = amount;
  }

  public Timestamp getSubmittedTime() {
    return submittedTime;
  }

  public void setSubmittedTime(Timestamp submittedTime) {
    this.submittedTime = submittedTime;
  }

  public Timestamp getResolvedTime() {
    return resolvedTime;
  }

  public void setResolvedTime(Timestamp resolvedTime) {
    this.resolvedTime = resolvedTime;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public int getAuthorId() {
    return authorId;
  }

  public void setAuthorId(int authorId) {
    this.authorId = authorId;
  }

  public int getResolverId() {
    return resolverId;
  }

  public void setResolverId(int resolverId) {
    this.resolverId = resolverId;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  @Override
  public String toString() {
    return "Reimbursement [reimbId=" + reimbId + ", amount=" + amount + ", submittedTime="
        + submittedTime + ", resolvedTime=" + resolvedTime + ", description=" + description
        + ", authorId=" + authorId + ", resolverId=" + resolverId + ", status=" + status + ", type="
        + type + "]";
  }

}
