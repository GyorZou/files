package com.zjp.utils;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSetMetaData;

public class JDBCDataBase {

	public String dbuname ;
	public String dbpwd;
	public String dburl;
	private Connection connection;
	private PreparedStatement statement;
	public void close() {
		closeStatementIfNeed();
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public JDBCDataBase(String dbuname, String dbpwd, String dburl) {
		super();
		this.dbuname = dbuname;
		this.dbpwd = dbpwd;
		this.dburl = dburl;
		
		
		
	}
	
	//curd
	
	private boolean openConnectionIfNeed() {
		if (connection == null) {
			try {
				JDBCUtils.log("begin connection...");
				connection = (Connection) DriverManager.getConnection(dburl, dbuname, dbpwd);
				JDBCUtils.log("connect success...");
			} catch (Exception e) {
				// TODO: handle exception
				JDBCUtils.log("fail connection to db:"+e.getLocalizedMessage());
				return false;
			}
		}	
		return true;
	}
	private void closeStatementIfNeed() {
		if (statement!=null) {
			try {
				statement.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally{
				statement=null;
			}
		}
	}
	private PreparedStatement createStatement(String sql,ArrayList<String> params){
		openConnectionIfNeed();
		PreparedStatement statement = null;
		try {
			JDBCUtils.log("preparing statement....");
			statement = (PreparedStatement) connection.prepareStatement(sql);
			
			if (params !=null) {
				for (int i = 0; i < params.size(); i++) {
					statement.setObject(i+1, params.get(i));
				}
			}
			
			JDBCUtils.log("success create statement....");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			JDBCUtils.log("error to prepare statement");
		}
		
		return statement;
	}
	public boolean update(String sql,ArrayList<String> paras) {
		closeStatementIfNeed();
		
		
		return true;
	}
	
	public boolean insert(String sql,ArrayList<String> params) {
		closeStatementIfNeed();
		openConnectionIfNeed();
		boolean isSuc =true;
		statement = createStatement(sql, params);
		if (statement != null) {
			try {
			
				 statement.execute();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				isSuc = false;
				JDBCUtils.log("insert fail:"+e.getLocalizedMessage());
				e.printStackTrace();
			}
		}
		return isSuc;
	}
	
	public HashMap<String, Object> qury(String sql,ArrayList<String> params) {
		closeStatementIfNeed();
		openConnectionIfNeed();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		statement = createStatement(sql, params);
		if (statement != null) {
			try {
				ResultSet set = statement.executeQuery();
				ResultSetMetaData rsdData = (ResultSetMetaData) set.getMetaData();
				int col = rsdData.getColumnCount();
				JDBCUtils.log("get datas with cols:"+col);
				while (set.next()) {
					for (int i = 0; i < col; i++) {
						 String cname = rsdData.getColumnName(i+1);
						 Object value = set.getObject(cname);
						 JDBCUtils.log("get data:"+cname + ",value:"+value);
						 map.put(cname, value);
					}
				
				}
				
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		return map;
	}
	
	public boolean delete(String sql,ArrayList<String> params) {
		closeStatementIfNeed();
		openConnectionIfNeed();
		
		return true;
	}
	
	


	
}
