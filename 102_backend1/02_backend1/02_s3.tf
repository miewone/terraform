resource "aws_s3_bucket" "terra_state"{
	bucket	=	"wgparkterra"
	#상태파일의 버젼관리 활성화 : 코드 이력 관리
	versioning	{
		enabled	=	true
	}
	# 서버 측 암호화 설정
	server_side_encryption_configuration {
		rule {
			apply_server_side_encryption_by_default {
				sse_algorithm	=	"AES256"
			}
		}
	}
	# 실수로 인한 삭제 방지
	lifecycle {
		prevent_destroy	=	false
	}
  
}