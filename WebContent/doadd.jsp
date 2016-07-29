<%@page import="java.util.Map"%>
<%@page import="cn.tf.student.utils.UploadUtil"%>
<%@page import="cn.tf.student.dao.StudentDao"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Random"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>



<%

	UploadUtil upload=new UploadUtil();
	Map<String,String> map=upload.upload(pageContext);
	
	StudentDao studentDao=new StudentDao();
	if(studentDao.add(map.get("cid"),map.get("sname"),map.get("age"),map.get("tel"),map.get("photo"))>0){
		response.sendRedirect("show.jsp");
	}else{
		response.sendRedirect("add.jsp");
	}
	



%>

    
  <%--   <%
    	request.setCharacterEncoding("UTF-8");
    	//创建一个磁盘文件项工厂
    	DiskFileItemFactory  factory=new DiskFileItemFactory();
    	
    	//通过工厂获取一个文件上传的对象
    	ServletFileUpload  upload=new ServletFileUpload(factory);
    	
    	//解析请求中的数据
    	List list=upload.parseRequest(request);
    	
    	StudentDao studentDao=new StudentDao();
    
    	FileItem item;
    	String fileName=null;
    	String name=null;
    	String cid=null;
    	String sname=null;
    	String age=null;
    	String tel=null;
    	String photo=null;
    	
    	
    	
    	for(int i=0,len=list.size();i<len;i++){
    		item=(FileItem) list.get(i);
    		
    		//如果是文件，说明是一个普通的表单元素
    		if(item.isFormField()==true){
    			name=item.getFieldName();
    			if("cid".equals(name)){
    				cid=item.getString("UTF-8");
    			}else if("sname".equals(name)){
    				sname=item.getString("utf-8");
    			}else if("age".equals(name)){
    				age=item.getString("utf-8");
    			}else if("tel".equals(name)){
    				tel=item.getString("utf-8");
    			}
    		}else{
    			if(item.getName()!=null && !"".equals(item.getName())){
    				/* System.out.println(item.getContentType());
    				System.out.println(item.getSize());
    				System.out.println(item.getName());
    				System.out.println(item.getFieldName()); */
    				
    				//到当前项目的webContext文件夹
    				//pageContext.getServletContext().getRealPath("/");
    				//pageContext.getServletContext().getContextPath();
    				
    				//获取上传的文件文件名
    				name=item.getName();
    				fileName=new Date().getTime()+""+new Random().nextInt(10000)+name.substring(name.lastIndexOf("."));
    				
    				File  readFile=new File(pageContext.getServletContext().getRealPath("/")+"upload",fileName);
    				
    				item.write(readFile);
    				photo="upload/"+fileName;
    			}else{
    				//说明用户没有选择任何文件
    				photo="";
    			}
    			
    		}
    	}
    
    	
    	//将数据添加到数据库
    	if(studentDao.add(cid,sname,age,tel,photo)>0){
    		response.sendRedirect("index.jsp");
    	}else{
    		response.sendRedirect("add.jsp");
    	}
    
   
    %> --%>