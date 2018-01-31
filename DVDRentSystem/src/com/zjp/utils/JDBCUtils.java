package com.zjp.utils;

import java.util.Date;



/**
 * @author jp007
 *
 */
public class JDBCUtils {
	
	static{
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
       
        }
        
    }

	
	
	
	/**
	 * 返回数据库对象
	 * @param dbUrl
	 * @param dbName
	 * @param dbPwd
	 * @return
	 */
	public static JDBCDataBase getDataBase(String dbUrl,String uname,String dbPwd) {
		
		//后续可以加池子
		JDBCDataBase db = new JDBCDataBase(uname, dbPwd, dbUrl);
		
		
		return db;
	}
	
	public static void log(String log) {
		Date date =new Date();
		System.out.println(date+":"+log);
	}
	

}
