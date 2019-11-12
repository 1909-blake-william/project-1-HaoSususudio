package org.deepfakenews.models;

public class UserLogin {
	private int userId;
	private String username;
	private String secureKey;
	private String salt;

	public UserLogin() {
		super();
	}

	public UserLogin(int userId, String username, String secureKey, String salt) {
		super();
		this.userId = userId;
		this.username = username;
		this.secureKey = secureKey;
		this.salt = salt;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
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

	@Override
	public String toString() {
		return "UserLogin [userId=" + userId + ", username=" + username + ", secureKey=" + secureKey + ", salt=" + salt
				+ "]";
	}

}
