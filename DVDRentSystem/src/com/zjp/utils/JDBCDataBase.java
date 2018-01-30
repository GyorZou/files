package com.zjp.utils;

import java.sql.DriverManager;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;

public class JDBCDataBase {

	public String dbuname ;
	public String dbpwd;
	public String dburl;
	private Connection connection;
	private PreparedStatement statement;
	public void close() {
		
	}

	public JDBCDataBase(String dbuname, String dbpwd, String dburl) {
		super();
		this.dbuname = dbuname;
		this.dbpwd = dbpwd;
		this.dburl = dburl;
		
		try {
			connection = (Connection) DriverManager.getConnection(dburl, dbuname, dbpwd);
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
	}
	
	
	


	
}
