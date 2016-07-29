<%@page import="cn.tf.student.utils.PageUtil"%>
<%@page import="cn.tf.student.entity.Student"%>
<%@page import="java.util.List"%>
<%@page import="cn.tf.student.dao.StudentDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta  charset="UTF-8">
<title>学生信息</title>
</head>
<style>
	table tr td img{
		width:200px;
		height:150px;
	}
	
	 a{
		text-decoration: none;
		padding:2px 10px;
		color:#fff;
		font-weight:bold;
		background:#ccc;
		margin-left:10px;
	}
	 a:hover{
		background-color:#ccc;
	}
	
	.over{
		background-color:blue;
	}
	.out{
		background-color:gray;
	}
	

</style>

<script type="text/javascript"  src="js/jquery-3.1.0.js"></script>
<script>

	$(function(){
		$.post("doshow.jsp",{op:1,pageNo:1,pageSize:5},function(data){
			var str="";
			$.each(data.studentInfo,function(index,item){
				str+="<tr><td>"+item.photo+"</td><td>"+item.sid+"</td><td>"+ 
				item.sname+"</td><td>"+item.age+"</td><td>"+item.tel+"</td><td>"+item.cname+"</td><td>删除</td></tr>";
			});
			$("#show_student").html("").append($(str));
			
			var total=parseInt(data.total);
			var page="";
			for(var i=0;i<total/5;i++){
				
				if(i==0){
					page+="<a href='javascript:findStudentByPage("+(i+1)+",5)' class='over' >"+(i+1)+"</a>";
					
				}else{
					page+="<a href='javascript:findStudentByPage("+(i+1)+",5)' class='out' >"+(i+1)+"</a>";
				}	
			}
			
			
			$("#pageInfo").html("").append($(page));
			
		},"json");	
	});
	
	function findStudentByPage(pageNo,pageSize){
		$.post("doshow.jsp",{op:2,pageNo:pageNo,pageSize:pageSize},function(data){
			var str="";
			$.each(data.studentInfo,function(index,item){
				str+="<tr><td>"+item.photo+"</td><td>"+item.sid+"</td><td>"+ 
				item.sname+"</td><td>"+item.age+"</td><td>"+item.tel+"</td><td>"+item.cname+"</td><td>删除</td></tr>";
			});
			$("#show_student").html("").append($(str));
			
		},"json");
		$("#pageInfo a").attr("class","out");
		$("#pageInfo a").eq(pageNo-1).attr("class","over");
	}
	

</script>



<body>

<center><a href="add.jsp" >返回添加</a></center>
<fieldset>
		<legend>学生信息浏览</legend>
		
		<table border="1px" cellspacing="0px" cellpaddig="0px" width="90%"  align="center"  style="border-collapse:collapse;"  >
			<thead>
				<tr>
					<th>图片</th>
					<th>学号</th>
					<th>姓名</th>
					<th>年龄</th>
					<th>联系方式</th>
					<th>所在班级</th>
					<th>操作</th>
				</tr>
			
			</thead>
			<tbody id="show_student"  align="center"  ></tbody>
		
		</table> 
		
	</fieldset>
	<br />
	<center id="pageInfo">
		 <a href="javascript:findStudentByPage(1,5)"  class="over">1</a>
		<a href="javascript:findStudentByPage(1,5)"  class="out">2</a> 
	
	
	</center>

</body>
</html>