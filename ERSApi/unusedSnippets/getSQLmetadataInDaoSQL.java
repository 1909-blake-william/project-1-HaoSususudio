  @Override
  public List<Reimbursement> findAll() {
//    log.debug("Attempting to find all Reimbursements from DB");

    try (Connection c = ConnectionUtil.getConnection()) {
      CallableStatement cs = c.prepareCall("call get_all_reimbursements(?)");
      cs.registerOutParameter(1, OracleTypes.CURSOR);
      cs.execute();

      ResultSet rs = (ResultSet) cs.getObject(1);
//      ResultSetMetaData rsmd = rs.getMetaData();
//      int columnsNumber = rsmd.getColumnCount();
//      while (rs.next()) {
//        for (int i = 1; i <= columnsNumber; i++) {
//          if (i > 1)
//            System.out.print(",  ");
//          String columnValue = rs.getString(i);
//          System.out.print(columnValue + " " + rsmd.getColumnName(i));
//        }
//        System.out.println("");
//      }

      List<Reimbursement> allReimbs = new ArrayList<>();
      while (rs.next()) {
        allReimbs.add(extractReimb(rs));
      }
      return allReimbs;
    } catch (SQLException e) {
      e.printStackTrace();
      return null;
    }
  }