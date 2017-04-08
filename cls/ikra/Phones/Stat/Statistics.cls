Class ikra.Phones.Stat.Statistics Extends %RegisteredObject
{

ClassMethod Min(a As %Numeric, b As %Numeric) As %Numeric
{
	if (a < b) { return a }
	else 	   { return b }
}

ClassMethod Mean(valueList As %List) As %Numeric
{
	
	set sum = 0
	set length = $listlength(valueList)
	
	if (length = 0) { return ""}
	
	for i=1:1:length {
		set sum = sum + $list(valueList, i)
	}
	
	return sum / length
}

ClassMethod Variance(valueList As %List) As %Numeric
{
	set sum = 0
	set length = $listlength(valueList)
	set mean = ..Mean(valueList)
	
	if (length = 0) { return ""}
	
	for i=1:1:length {
		set sum = sum + $zpower(($list(valueList,i) - mean), 2)
	}	
	
	return sum / length
}

ClassMethod StdDev(valueList As %List) As %Numeric
{
	return $zsqr(..Variance(valueList))
}

ClassMethod Cov(listX As %List, listY As %List) As %Numeric
{
	set meanX = ..Mean(listX)
	set meanY = ..Mean(listY)
	
	set sum = 0
	set n = ..Min($listlength(listX), $listlength(listY))
	
	for i=1:1:n {
		set sum = sum + (($list(listX, i) - meanX) * ($list(listY, i) - meanY))
	}
	
	return sum / n
}

ClassMethod CorrelationCoefficient(listX As %List, listY As %List) As %Numeric
{
	set covariation = ..Cov(listX, listY)
	set stdDevX = ..StdDev(listX)
	set stdDevY = ..StdDev(listY)
	
	return covariation / (stdDevX * stdDevY)
}

}

