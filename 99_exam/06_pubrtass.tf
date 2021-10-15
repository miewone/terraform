resource "aws_route_table_association" "wgpark_puba_ass" {
  subnet_id = aws_subnet.wgpark_puba.id
  route_table_id = aws_route_table.wgpark_pubrt.id
}
resource "aws_route_table_association" "wgpark_pubc_ass" {
  subnet_id = aws_subnet.wgpark_pubc.id
  route_table_id = aws_route_table.wgpark_pubrt.id
}