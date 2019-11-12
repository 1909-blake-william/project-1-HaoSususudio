package org.deepfakenews.models;

public class UserInfo {
  private int userId;
  private String firstName;
  private String lastName;
  private String email;
  private String userRole;

  public UserInfo() {
    super();
  }

  public UserInfo(int userId, String firstName, String lastName, String email, String userRole) {
    super();
    this.userId = userId;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.userRole = userRole;
  }

  public int getUserId() {
    return userId;
  }

  public void setUserId(int userId) {
    this.userId = userId;
  }

  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getUserRole() {
    return userRole;
  }

  public void setUserRole(String userRole) {
    this.userRole = userRole;
  }

  @Override
  public String toString() {
    return "UserInfo [userId=" + userId + ", firstName=" + firstName + ", lastName=" + lastName
        + ", email=" + email + ", userRole=" + userRole + "]";
  }

}
