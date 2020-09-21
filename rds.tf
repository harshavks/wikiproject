resource "aws_db_subnet_group" "wiki" {
  name       = "wiki-subnet"
  subnet_ids = [aws_subnet.wiki-private-1.id, aws_subnet.wiki-private-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_instance" "wikidb" {
  identifier          = "wikidatabase"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "wikidatabase"
  username             = "wiki"
  password             = "Wiki1234"
  skip_final_snapshot = "true"
  db_subnet_group_name = aws_db_subnet_group.wiki.name
  vpc_security_group_ids = [aws_security_group.wiki-rds-sg.id]
}


