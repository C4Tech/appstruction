function getSquareFeet(height,width,depth)
{
	return height * width * depth;
}

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}