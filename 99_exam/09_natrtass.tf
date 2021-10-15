resource "aws_route_table_association" "wgpark_pria_ass" {
  subnet_id = aws_subnet.wgpark_pria.id
  route_table_id = aws_route_table.wgpark_natrt_pria.id
}
resource "aws_route_table_association" "wgpark_pric_ass" {
  subnet_id = aws_subnet.wgpark_pric.id
  route_table_id = aws_route_table.wgpark_natrt_pric.id
}