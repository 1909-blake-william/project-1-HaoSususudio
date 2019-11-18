package org.deepfakenews.models;

public class NewReimbReq {
  double amount;
  Integer authorId;
  String description;
  Integer typeId;

  public NewReimbReq() {
    super();
  }

  public NewReimbReq(double amount, Integer authorId, String description, Integer typeId) {
    super();
    this.amount = amount;
    this.authorId = authorId;
    this.description = description;
    this.typeId = typeId;
  }

  public double getAmount() {
    return amount;
  }

  public void setAmount(double amount) {
    this.amount = amount;
  }

  public Integer getAuthorId() {
    return authorId;
  }

  public void setAuthorId(Integer authorId) {
    this.authorId = authorId;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public Integer getTypeId() {
    return typeId;
  }

  public void setTypeId(Integer typeId) {
    this.typeId = typeId;
  }

  @Override
  public String toString() {
    return "NewReimbPost [amount=" + amount + ", authorId=" + authorId + ", description="
        + description + ", typeId=" + typeId + "]";
  }

}
