/// Методы работы с кубами аналитики
Class ikra.util.DeepSeeUtils Extends %RegisteredObject
{

ClassMethod updateDSCubes(cubeName As %String) As %Status
{
	
	#dim status As %Status
	set status = ##class(%DeepSee.Utils).%BuildCube(cubeName)
	quit status
}

}

