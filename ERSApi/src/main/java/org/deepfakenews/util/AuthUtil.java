package org.deepfakenews.util;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Arrays;
import java.util.Base64;
import java.util.Optional;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import org.deepfakenews.daos.UserLoginDao;
import org.deepfakenews.models.UserLogin;

public class AuthUtil {
  public static final AuthUtil instance = new AuthUtil();
  private UserLoginDao userLoginDao = UserLoginDao.currentImplementation;
  private UserLogin currentUserLogin = null;

  private AuthUtil() {
    super();
  }

  public UserLogin login(String username, String password) {
    UserLogin u = userLoginDao.findByUsername(username);
    if (u == null) {
      return null;
    }

    String key = u.getSecureKey();
    String salt = u.getSalt();
    if (verifyPassword(password, key, salt)) {
      currentUserLogin = u;
      return u;
    } else {
      return null;
    }

  }

  public UserLogin loginAsAdmin(String adminUsername, String password) {
    UserLogin u = login(adminUsername, password);
    if (u == null) {
      return null;
    } else if ("admin".equals(u.getRole())) {
      currentUserLogin = u;
      return u;
    } else {
      return null;
    }
  }

//  public void generateAndSaveNewUserLogin(String username, String password) {
//    String salt = generateSalt().get();
//    String key = hashPassword(password, salt).get();
//    TempObjUtil.userLoginInst.setSaltForPassword(salt);
//    TempObjUtil.userLoginInst.setSecureKey(key);
//    UserLoginDao userDao = UserLoginDao.currentImplementation;
//    userDao.save(TempObjUtil.userLoginInst);
//  }

  public boolean ifUserExistsInDB(String username) {
    UserLogin u = userLoginDao.findByUsername(username);
    return u != null ? true : false;
  }

  public UserLogin getCurrentUserLogin() {
    return currentUserLogin;
  }

  public void logout() {
    currentUserLogin = null;
  }

  /**
   * Following password hashing utilities is modified from:
   * https://dev.to/awwsmm/how-to-encrypt-a-password-in-java-42dh
   *
   * Password hashing parameters:
   */
  private static final int SALT_LENGTH = 16;
  private static final int ITERATIONS = 1909;
  private static final int KEY_LENGTH = 128;
  private static final String ALGORITHM = "PBKDF2WithHmacSHA512";

  private static final SecureRandom RAND = new SecureRandom();

  /**
   * Random generation of salt to be used for password hashing
   * 
   * @return
   */
  public static Optional<String> generateSalt() {

    byte[] salt = new byte[SALT_LENGTH];
    RAND.nextBytes(salt);

    return Optional.of(Base64.getEncoder().encodeToString(salt));
  }

  public static Optional<String> hashPassword(String password, String salt) {

    char[] chars = password.toCharArray();
    byte[] bytes = salt.getBytes();

    PBEKeySpec spec = new PBEKeySpec(chars, bytes, ITERATIONS, KEY_LENGTH);

    Arrays.fill(chars, Character.MIN_VALUE);

    try {
      SecretKeyFactory fac = SecretKeyFactory.getInstance(ALGORITHM);
      byte[] securePassword = fac.generateSecret(spec).getEncoded();
      return Optional.of(Base64.getEncoder().encodeToString(securePassword));

    } catch (NoSuchAlgorithmException | InvalidKeySpecException ex) {
      System.err.println("Exception encountered in hashPassword()");
      return Optional.empty();

    } finally {
      spec.clearPassword();
    }
  }

  public static boolean verifyPassword(String password, String key, String salt) {
    Optional<String> optEncrypted = hashPassword(password, salt);
    if (!optEncrypted.isPresent())
      return false;
    return optEncrypted.get().equals(key);
  }

}
