package org.deepfakenews.daos;

import java.util.List;

import org.deepfakenews.models.UserInfo;

public interface UserInfoDao {
  UserInfoDao currentImplementation = new UserInfoDaoSQL();

  List<UserInfo> findAll();

  UserInfo findById(int userId);
}
