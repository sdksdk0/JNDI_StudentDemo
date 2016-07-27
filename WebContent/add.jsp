<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta  charset="UTF-8">
<title>图片上传</title>
<script src="js/jquery-3.1.0.js"  ></script>
</head>

<script>


	
	
$(function(){
		$.post("doaddclasses.jsp",{op:"findClasses"},function(data){
			
			if(data!=""){
				$.each(data,function(index,item){
					$("#classesInfo").append($("<option value='"+item.cid+"'>"+item.cname+"</option>"));
				});
			}
		},"json");
	});

		
	function addStudent(){
		var sname=$.trim($("#sname").val());
		if(sname!=""){
			$("#add_student").submit();
		
		}else{
			return;
		}
	}


</script>

<body>

	
	<form action="doadd.jsp"  method="post"  id="add_student"  enctype="multipart/form-data">
		
			班级:<select name="cid"  id="classesInfo" >
			
			
			</select>
			姓名:<input type="text"  name="sname"  id="sname" />
			年龄:<input type="number" name="age"  min="1"  id="age" />
			联系方式:<input type="text" name="tel" id="tel" />
			图片:<input type="file" name="photo"  />
			<input type="button"  value="添加"   onclick="addStudent()" />

		</form>

</body>
</html>