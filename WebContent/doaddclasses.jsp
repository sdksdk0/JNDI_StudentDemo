<%@page import="cn.tf.student.entity.Classes"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="cn.tf.student.dao.ClassesDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
    <%
    	request.setCharacterEncoding("UTF-8");
		ClassesDao classesDao=new ClassesDao();
		
    	String op=request.getParameter("op");
    	if("addClasses".equals(op)){
    		String cname=request.getParameter("cname");
        
        	int result=classesDao.add(cname);
        	
        	out.println(result);
    	}else if("findClasses".equals(op)){
    		List<Map<String,Object>> list=classesDao.find();
    		
    		//StringBuffer sb=new StringBuffer();
    		
    		/* StringBuffer sb=new StringBuffer("[");
    		String str=""; */
    		
    	/* 	if(list!=null && list.size()>0){
    			for(Map<String,Object>  map:list){
    				//sdf.append("<option value=;"+map.get("CID");
    				sb.append(map.get("CID")+"-"+map.get("CNAME")+",");
    			}
    			str=sb.toString();
    			str=str.substring(0,str.lastIndexOf(","));
    		} */
    		
    /* 		Map<String,Object>  map;
    		int i=0,len=0;
    		if(list!=null && list.size()>0){
    			for(i=0,len=list.size();i<len-1;i++){
    				map=list.get(i);
    				sb.append("{\"cid\":\""+map.get("CID")+"\",\"cname\":\""+map.get("CNAME")+"\"},");
    			}
    			map=list.get(i);
    			sb.append("{\"cid\":\""+map.get("CID")+"\",\"cname\":\""+map.get("CNAME")+"\"}");
    			sb.append("]");
    			str=sb.toString();
    		
    		} 
    		
    		out.println(str);
    		*/
    		StringBuffer sb=new StringBuffer("[");

    		List<Classes>  list1=classesDao.finds();
    		
    		for(Classes c:list1){
    			sb.append(c+",");
    		}
    		String str=sb.toString();
    		str=str.substring(0,str.lastIndexOf(","));
    		out.println(str+"]");
    		
    		
    		
    	}
 
    
    %>