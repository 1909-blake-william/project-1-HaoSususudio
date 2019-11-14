package org.deepfakenews.models;

public class UserLogin {
  private String username;
  private String secureKey;
  private String salt;
  private String role;

  public UserLogin() {
    super();
  }

  public UserLogin(String username, String secureKey, String salt, String role) {
    super();
    this.username = username;
    this.secureKey = secureKey;
    this.salt = salt;
    this.role = role;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getSecureKey() {
    return secureKey;
  }

  public void setSecureKey(String secureKey) {
    this.secureKey = secureKey;
  }

  public String getSalt() {
    return salt;
  }

  public void setSalt(String salt) {
    this.salt = salt;
  }

  public String getRole() {
    return role;
  }

  public void setRole(String role) {
    this.role = role;
  }

  @Override
  public String toString() {
    return "UserLogin [username=" + username + ", secureKey=" + secureKey + ", salt=" + salt
        + ", role=" + role + "]";
  }

}
