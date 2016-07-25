<%@page import="cn.tf.student.entity.Student"%>
<%@page import="cn.tf.student.dao.StudentDao"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
    <%
    	request.setCharacterEncoding("UTF-8");
    
		StudentDao studentDao=new StudentDao();
		
		String cid=request.getParameter("cid");
		String sname=request.getParameter("sname");
		String age=request.getParameter("age");
		String tel=request.getParameter("tel");
		
		
		if(studentDao.add(cid,sname,age,tel,"")>0){
			List<Student> list=studentDao.find();
			if(list!=null && list.size()>0){
				StringBuffer sb=new StringBuffer("[");
				for(Student stu:list){
					sb.append(stu+",");
				}
				String str=sb.toString();
				str=str.substring(0,str.lastIndexOf(","));
				out.print(str+"]");
			}
		}else{
			out.print("");
		}
    
    %>