<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
    <%
    	request.setCharacterEncoding("UTF-8");
    	//创建一个磁盘文件项工厂
    	DiskFileItemFactory  factory=new DiskFileItemFactory();
    	
    	//通过工厂获取一个文件上传的对象
    	ServletFileUpload  upload=new ServletFileUpload(factory);
    	
    	//解析请求中的数据
    	List list=upload.parseRequest(request);
    	
    	FileItem item=null;
    	for(int i=0,len=list.size();i<len;i++){
    		item=(FileItem) list.get(i);
    		
    		//如果是文件，说明是一个普通的表单元素
    		if(item.isFormField()==true){
    			System.out.println(item.getFieldName()+"  "+item.getString("UTF-8"));
    		}else{
    			if(item.getName()!=null && !"".equals(item.getName())){
    				System.out.println(item.getContentType());
    				System.out.println(item.getSize());
    				System.out.println(item.getName());
    				System.out.println(item.getFieldName());
    			}
    			
    		}
    	}
    
    
    
    
    %>