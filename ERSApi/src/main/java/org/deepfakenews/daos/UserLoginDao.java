package org.deepfakenews.daos;

import org.deepfakenews.models.UserLogin;

public interface UserLoginDao {

  UserLoginDao currentImplementation = new UserLoginDaoSQL();

  UserLogin findByUsername(String username);
}
