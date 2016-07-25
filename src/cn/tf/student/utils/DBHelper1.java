package cn.tf.student.utils;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;





public class DBHelper1 {
	/**
	 * 加载驱动的功能：静态块来加载   因为静态块在程序一加载到JVM就会运行，这时驱动就加载好了
	 */
	// 封装连接
		public Connection getConnection() {
			Connection con = null;
			try {
				Context ct = new InitialContext();
				DataSource ds= (DataSource) ct.lookup("java:comp/env/jdbc");
				con = ds.getConnection();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return con;
		}

	/**
	 *更新的方法（DML中的insert update  delete） 
	 *@param 
	 *				sql要执行的语句
	 *@param:params
	 *				?代表的值
	 * @return：语句执行后，影响的数据的行数
	 * @param pstmt：要赋值的预编译
	 * @param params：对应的占位符的值的集合
	 */
	public int doUpdate(String sql,List<String> params){
		Connection con=getConnection();
		//表示预编译的 SQL 语句的对象
		PreparedStatement pstmt=null;
		int result=0;
		try{
			pstmt=con.prepareStatement(sql);
			//判断params是否为空，如果不为空说明用户给定的sql语句中含有占位符
			setParams(params, pstmt);
			//执行
			result=pstmt.executeUpdate();
		}catch( SQLException e ){
			e.printStackTrace();
		}finally{
			closeAll( pstmt,con);
		}
		return result;
	}

	/*
		执行DDL操作：创建、删除、修改表，约束、序列
	 */
	public void doDDL(String sql,List<String> params){
		Connection con=null;
		PreparedStatement pstmt=null;
		try {
			con=getConnection();  //获取连接
			pstmt=con.prepareStatement(sql);
			System.out.println(sql);
			setParams(params,pstmt);
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();  //抑制异常 ,对已成 不做处理，底层无任何反应
			throw new RuntimeException(e);
		}finally{
			closeAll(pstmt,con);
		}
	}


	private void setParams(List<String> params, PreparedStatement pstmt)
			throws SQLException {
		if( params !=null && params.size()>0){
			for( int i=1;i<=params.size();i++){
				pstmt.setString(i, (String) params.get(i-1));
			}
		}
	}
	
	/**
	 * 
	 *
	 * 
	 * */

	public <T> List<T> find(String  sql,List<String> params,Class<T> c){
		List<T> list=new ArrayList<T>();
		Connection con=getConnection();
		
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=this.getConnection();
			pstmt=con.prepareStatement(sql);
			this.setParams(params, pstmt);
			rs=pstmt.executeQuery();
			
			
			//将结果集中的每一条记录注入到一个对象中
			//1、获取结果集中的么一个列的名称，并将其存放在一个数组中
			List<String> cols=this.getColumnName(rs);
			//2、获取给定类的所有setter方法
			Method[] methods=c.getMethods();
			
			//setCID  setcid
			T t=null;
			String cname=null;
			String mname=null;
			String ctypeName=null;
			
			while(rs.next()){
				
				t=c.newInstance();  //创建类的实例化对象
				
				for(int i=0,len=cols.size();i<len;i++){
					cname=cols.get(i);
					//从类的方法中招对应的setter方法
					if(methods!=null && methods.length>0){
						for (Method method : methods) {
							mname=method.getName();  //获取当前循环的这个方法的方法名
							
							if(("set"+cname).equalsIgnoreCase(mname) && rs.getObject(cols.get(i))!=null){
								//如果找到了对应的setter方法，则激活这个方法，将这个列的值注入进去
								ctypeName=rs.getObject(cols.get(i)).getClass().getSimpleName();
									
								if("String".equals(ctypeName)){
									method.invoke(t, rs.getString(cname));
								}else if("BigDecimal".equals(ctypeName)){
									try {
										method.invoke(t, rs.getInt(cname));
									} catch (Exception e) {
										method.invoke(t, rs.getDouble(cname));
									}
								}else{
									method.invoke(t, rs.getString(cname));
								}
								break;
							}
						}
					}
				}
				
				list.add(t);
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			closeAll(rs,pstmt,con);
		}
		
		return list;
		
	}
	

	/*
		查询聚合函数
	 */
	public double doSelectFunction( String sql,List<String> params){
		Connection con=getConnection();
		PreparedStatement pstmt=null;
		double result=0;
		ResultSet rs=null;

		try {
			pstmt=con.prepareStatement(sql);
			setParams(params, pstmt);
			rs = pstmt.executeQuery();//聚合函数也是一种查询
			if( rs.next()){  //聚合函数是单行单列
				result=rs.getDouble(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			//throw e;  //受检异常Exception(e)，系统的侵入性大 
			throw new RuntimeException(e);  //1 早抛出晚捕获    在dao层代码中不处理异常，由界面以友好的方式 处理   2、异常类型的选择（受检异常、非受检异常）
		}finally{
			closeAll(rs,pstmt,con);
		}
		return result;
	}

	//集合长度不固定，可以存储数据库中的表格信息
	/**
	 * 查询一：查询出来的结果是一个Lis<Map<String,String>>
	 * 	map中的建记录的列名  map的值记录的是值
	 * Map对应的数据表的一条记录
	 * List对应数据表中的全部记录
	 * **/
	public List<Map<String,String>> find(String sql,List<String> params){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		List<Map<String,String>> list=new ArrayList<Map<String,String>>();
		
		try {
			con=getConnection();
			pstmt=con.prepareStatement(sql);
			setParams(params, pstmt);
			//得到结果集
			rs=pstmt.executeQuery();  
			//得到所有列名
			List<String> columnNameList= getColumnName(rs);
			//循环结果，取出结果
			while( rs.next()){
				//每next（）一次，就是一条记录
				Map<String,String> map=new HashMap<String,String>();
				//将值存到map中
				//rs.get类型(存的序号/列名)
				//循环columnNname，取出每个列的名字，在根据列名，以rs.get类型（列名）
				//取出这一列的值
				for( String cn:columnNameList){
					String value=rs.getString(cn);
					map.put(cn, value);
				}
				list.add(map);  //将这个map存到list中，一个list对应一个查询的结果
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException( e);
		}finally{
			closeAll(rs,pstmt,con);
		}
		return list;
	}
	
	
	
	
	/**
	 * @throws SQLException 
	 * 
	 * 
	 * */
	public List<String> getColumnName(ResultSet rs) throws SQLException{
		if( rs==null){
			return null;
		}
		List<String>columnList=new ArrayList<String>();
		ResultSetMetaData rsmd= rs.getMetaData();
		for ( int i=0;i<rsmd.getColumnCount();i++){
			columnList.add( rsmd.getColumnLabel(i+1));
		}
		return columnList;
	}
	
	
	
	
	
	
	
	/**
	 *关闭 
	 */	
	public void closeAll(PreparedStatement pstmt,Connection con){
		if( pstmt!=null){
			try {
				pstmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if( con !=null){
			try {
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}


	/**
	 *关闭资源重载
	 */	
	public void closeAll(ResultSet rs,PreparedStatement pstmt,Connection con){
		if( rs!=null){
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		closeAll(pstmt,con);
	}
}
