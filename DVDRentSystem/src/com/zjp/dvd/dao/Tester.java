package com.zjp.dvd.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import com.zjp.utils.JDBCDataBase;
import com.zjp.utils.JDBCUtils;

public class Tester {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String url ="jdbc:mysql://localhost:3306/dvdsys";
		JDBCDataBase base =  JDBCUtils.getDataBase(url, "root", "123");

		ArrayList<String> params = new ArrayList<String>();
		
		params.add("zjp3");
		params.add("123456");
		boolean isSuc = base.insert("insert into user(name,pwd,createdate) values (?,?,now())",params);
		System.out.println(isSuc==true?"insert user suc":" inser user fail");
		
		
		HashMap<String, Object> map = base.qury("select * from user", null);
		Set<Entry<String, Object>> entry =  map.entrySet();
		for (Entry<String, Object> entry2 : entry) {
			String key = entry2.getKey();
			Object valueObject = entry2.getValue();
			System.out.println("get a recordm,key="+key+" ,value:"+valueObject);
		}
		
	}

}
