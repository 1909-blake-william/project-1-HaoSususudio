package org.deepfakenews.models;

public class UpdateReimbStatusReq {
  Integer reimbId;
  Integer statusId;
  Integer resolverId;

  public UpdateReimbStatusReq() {
    super();
    // TODO Auto-generated constructor stub
  }

  public UpdateReimbStatusReq(Integer reimbId, Integer statusId, Integer resolverId) {
    super();
    this.reimbId = reimbId;
    this.statusId = statusId;
    this.resolverId = resolverId;
  }

  public Integer getReimbId() {
    return reimbId;
  }

  public void setReimbId(Integer reimbId) {
    this.reimbId = reimbId;
  }

  public Integer getStatusId() {
    return statusId;
  }

  public void setStatusId(Integer statusId) {
    this.statusId = statusId;
  }

  public Integer getResolverId() {
    return resolverId;
  }

  public void setResolverId(Integer resolverId) {
    this.resolverId = resolverId;
  }

  @Override
  public String toString() {
    return "PutReimbReqest [reimbId=" + reimbId + ", statusId=" + statusId + ", resolverId="
        + resolverId + "]";
  }

}
