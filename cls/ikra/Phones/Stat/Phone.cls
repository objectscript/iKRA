Class ikra.Phones.Stat.Phone Extends (%Persistent, %XML.Adaptor)
{

/// Phone ID.
Property PhoneId As %Integer [ Required ];

Index PhoneIdIndex On PhoneId [ Unique ];

/// Phone Name.
Property PhoneName As %String [ Required ];

Index PhoneNameIndex On PhoneName;

/// Author's rating of phone.
Property UserRating As %Numeric;

/// Estimated rating of phone.
Property iKnowRating As %Numeric;

/// Estimated rating of hotel without excluding functional markers.
Property iKnowEmarkersRating As %Numeric;

/// Estimated rating of comfort.
Property iKnowRatingComfort As %Numeric;

/// Estimated rating of location.
Property iKnowRatingPerfomance As %Numeric;

/// Estimated rating of service.
Property iKnowRatingLink As %Numeric;

/// Estimated rating of food.
Property iKnowRatingCamera As %Numeric;

/// Number of reviews.
Property ReviewsCount As %Integer;

/// Negative reviews percent.
Property NegativeReviewsPCT As %Numeric;

/// Positive reviews percent.
Property PositiveReviewsPCT As %Numeric;

/// Neutral reviews percent.
Property NeutralReviewsPCT As %Numeric;

/// A list of sentences from the reviews characterizing comfort of the phone.
Property SentComfort As %List;

/// A list of sentences from the reviews characterizing perfomance of the phone.
Property SentPerfomance As %List;

/// A list of sentences from the reviews characterizing link of the hotel.
Property SentLink As %List;

/// A list of sentences from the reviews characterizing camera of the hotel.
Property SentCamera As %List;

/*ClassMethod GetFinalText(phoneId As %Integer) As %String
{
	set reviewCount = 0
	set iKnowRatingPositive = 0
	set iKnowRatingComfortPositive = 0
	set iKnowRatingFoodPositive = 0
	set iKnowRatingHospitalityPositive = 0
	set iKnowRatingLocationPositive = 0
	set iKnowRatingServicePositive = 0
	set iKnowRatingTerritoryPositive = 0
	set iKnowRatingNegative = 0
	set iKnowRatingComfortNegative = 0
	set iKnowRatingFoodNegative = 0
	set iKnowRatingHospitalityNegative = 0
	set iKnowRatingLocationNegative = 0
	set iKnowRatingServiceNegative = 0
	set iKnowRatingTerritoryNegative = 0
	set comfortText = ""
	set hospitalityText = ""
	set foodText = ""
	set serviceText = ""
	set extraText = ""
	
	// Obtain the cursor
	&sql(DECLARE crsr CURSOR FOR
	     SELECT id, iKnowRating, iKnowEmarkersRating, iKnowRatingComfort, iKnowRatingFood,
	            iKnowRatingHospitality, iKnowRatingLocation, iKnowRatingService, iKnowRatingTerritory 
	     INTO :id, :iKnowRating, :iKnowEmarkersRating, :iKnowRatingComfort, :iKnowRatingFood,
	     	  :iKnowRatingHospitality, :iKnowRatingLocation, :iKnowRatingService, :iKnowRatingTerritory
	     FROM ikra_Hotels_Stat.Review
	     WHERE HotelId = :hotelId
	)	
	
	// Open cursor
	&sql(open crsr)
	&sql(fetch crsr)
	
	// Loop through cursor.
	while (SQLCODE '= 100)
	{
		set reviewCount = reviewCount + 1
		
		if (iKnowRating > 3) { set iKnowRatingPositive = iKnowRatingPositive + 1}
		elseif (iKnowRating '= "") { set iKnowRatingNegative = iKnowRatingNegative + 1 }
		
		if (iKnowRatingComfort > 3) { set iKnowRatingComfortPositive = iKnowRatingComfortPositive + 1}
		elseif (iKnowRatingComfort '= "") { set iKnowRatingComfortNegative = iKnowRatingComfortNegative + 1}
		
		if (iKnowRatingFood > 3) { set iKnowRatingFoodPositive = iKnowRatingFoodPositive + 1 }
		elseif (iKnowRatingFood '= "") { set iKnowRatingFoodNegative = iKnowRatingFoodNegative + 1 }
		
		if (iKnowRatingHospitality > 3) { set iKnowRatingHospitalityPositive = iKnowRatingHospitalityPositive + 1 }
		elseif (iKnowRatingHospitality '= "") { set iKnowRatingHospitalityNegative = iKnowRatingHospitalityNegative + 1 }
		
		if (iKnowRatingLocation > 3) { set iKnowRatingLocationPositive = iKnowRatingLocationPositive + 1 }
		elseif (iKnowRatingLocation '= "") { set iKnowRatingLocationNegative = iKnowRatingLocationNegative + 1 }
		
		if (iKnowRatingService > 3) { set iKnowRatingServicePositive = iKnowRatingServicePositive + 1 }
		elseif (iKnowRatingService '= "") { set iKnowRatingServiceNegative = iKnowRatingServiceNegative + 1}
		
		if (iKnowRatingTerritory > 3) { set iKnowRatingTerritoryPositive = iKnowRatingTerritoryPositive + 1 }
		elseif (iKnowRatingTerritory '= "") { set iKnowRatingTerritoryNegative = iKnowRatingTerritoryNegative + 1 }
		
		&sql(fetch crsr)
	}
		
	&sql(close crsr)
	
	if (reviewCount = 0) { 
		return "Нет отзывов по данному отелю."
	}
	
	// Obtain Hotel name.
	&sql(SELECT HotelName INTO :hotelName FROM ikra_Hotels_Stat.Hotel WHERE HotelId = :hotelId)
	
	// Получаем обращение, в зависимости от числа
	set lastChar = $extract(reviewCount,*-0)
	set word = $case(lastChar, "1":"человека", :"человек")
	
	set finalText = "Из "_reviewCount_" "_word_", отдыхавших в отеле "_hotelName_", " 
	
	set var = $random(6) + 1
	
	if (iKnowRatingPositive > iKnowRatingNegative) 
	{
		set hotelText = $case(var,
							  1:"довольны отелем остались ",
							  2:"отель в целом понравился ",
							  3:"отель пришелся по душе ",
							  4:"отель оценили положительно ",
							  5:"посчитали отель хорошим ",
							  6:"остались довольны отелем ")
		
		set hotelText = hotelText_" - "_iKnowRatingPositive_" ("_$NORMALIZE((iKnowRatingPositive / reviewCount * 100), 0)_"%)"					  
							  
	}
	else 
	{
		set hotelText = $case(var,
							  1:"недовольны отелем остались ",
							  2:"отель в целом не понравился ",
							  3:"отель оставил негативное впечатление у ",
							  4:"отель оценили отрицательно ",
							  5:"посчитали отель неудовлетворительным ",
							  6:"остались недовольны отелем ")
							  
		set hotelText = hotelText_" - "_iKnowRatingNegative_" ("_$NORMALIZE((iKnowRatingNegative / reviewCount * 100), 0)_"%)"								  
	}
	
	set finalText = finalText_hotelText_", "	
	
	set var = $random(6) + 1
	
	if (((iKnowRatingComfortPositive + iKnowRatingComfortNegative)/ reviewCount) > 0)
	{
	
		if (iKnowRatingComfortPositive > iKnowRatingComfortNegative) 
		{
			set comfortText = $case(var,
								  1:"условия посчитали комфортными ",
								  2:"понравились условия ",
								  3:"в отеле чувствовали себя комфортно ",
								  4:"комфортабельность оценили положительно ",
								  5:"остались довольны условиями ",
								  6:"посчитали условия комфортными ")
			
			set comfortText = comfortText_"- "_iKnowRatingComfortPositive_" ("_$NORMALIZE((iKnowRatingComfortPositive / (iKnowRatingComfortPositive + iKnowRatingComfortNegative) * 100), 0)_"%*), "					  
								  
		}
		else 
		{
			set comfortText = $case(var,
								  1:"не понравились условия ",
								  2:"условия посчитали некомфортными ",
								  3:"в отеле чувствували себя некомфортно ",
								  4:"комфортабельность оценили отрицательно ",
								  5:"остались недовольны условиями ",
								  6:"посчитали условия некомфортными ")
								  
			set comfortText = comfortText_"- "_iKnowRatingComfortNegative_" ("_$NORMALIZE((iKnowRatingComfortNegative / (iKnowRatingComfortPositive + iKnowRatingComfortNegative) * 100), 0)_"%*), "								  
		}	
	}
	
	set var = $random(6) + 1
	
	if (((iKnowRatingFoodPositive + iKnowRatingFoodNegative)/ reviewCount) > 0)
	{
		if (iKnowRatingFoodPositive > iKnowRatingFoodNegative) 
		{
			set foodText = $case(var,
								  1:"понравилась еда и питание",
								  2:"понравилась еда в ресторанах",
								  3:"положительно оценили качество пищи",
								  4:"остались довольны качеством еды",
								  5:"понравилось питание",
								  6:"высоко оценили качество пищи")
			
			set foodText = iKnowRatingFoodPositive_" ("_$NORMALIZE((iKnowRatingFoodPositive / (iKnowRatingFoodPositive + iKnowRatingFoodNegative) * 100), 0)_"%*) "_foodText_", "					  
								  
		}
		else 
		{
			set foodText = $case(var,
								  1:"не понравилась еда и питание",
								  2:"не понравилась еда в ресторанах",
								  3:"отрицательно оценили качество пищи",
								  4:"остались недовольны качеством еды",
								  5:"не понравилось питание",
								  6:"низко оценили качество пищи")
								  
			set foodText = iKnowRatingFoodNegative_" ("_$NORMALIZE((iKnowRatingFoodNegative / (iKnowRatingFoodPositive + iKnowRatingFoodNegative) * 100), 0)_"%*) "_foodText_", "								  
		}	
	}
	
	set var = $random(6) + 1
	
	if (((iKnowRatingHospitalityPositive + iKnowRatingHospitalityNegative)/ reviewCount) > 0)
	{
		if (iKnowRatingHospitalityPositive > iKnowRatingHospitalityNegative) 
		{
			set hospitalityText = $case(var,
								  1:"отметили вежливость и приветливость персонала",
								  2:"понравилось отношение персонала",
								  3:"отметили гостеприимность персонала отеля",
								  4:"остались довольны работой персонала",
								  5:"высоко оценили уровень работы перонала",
								  6:"понравилось отношение персонала отеля")
			
			set hospitalityText = hospitalityText_" - "_iKnowRatingHospitalityPositive_" ("_$NORMALIZE((iKnowRatingHospitalityPositive / (iKnowRatingHospitalityPositive + iKnowRatingHospitalityNegative) * 100), 0)_"%*), "					  
								  
		}
		else 
		{
			set hospitalityText = $case(var,
								  1:"отметили плохое отношение персонала",
								  2:"не порнавилось отношение персонала",
								  3:"отметили негостеприимность персонала",
								  4:"остались недовольны работой персонала",
								  5:"низко оценили уровень работы персонала",
								  6:"не понравилось отношение персонала отеля")
								  
			set hospitalityText = hospitalityText_" - "_iKnowRatingHospitalityNegative_" ("_$NORMALIZE((iKnowRatingHospitalityNegative / (iKnowRatingHospitalityPositive + iKnowRatingHospitalityNegative) * 100), 0)_"%*), "								  
		}	
	}
	
	set var = $random(6) + 1
	
	if (((iKnowRatingServicePositive + iKnowRatingServiceNegative)/ reviewCount) > 0)
	{
		if (iKnowRatingServicePositive > iKnowRatingServiceNegative) 
		{
			set serviceText = $case(var,
								  1:"понравилось рзнообразие и качество услуг",
								  2:"отметили высокий уровень сервиса",
								  3:"остались довольны качеством услуг",
								  4:"высоко оценили качество предоставляемых услуг",
								  5:"высоко оценили уровень сервиса",
								  6:"положительно оценили качество сервиса")
			
			set serviceText = serviceText_" - "_iKnowRatingServicePositive_" ("_$NORMALIZE((iKnowRatingServicePositive / (iKnowRatingServicePositive + iKnowRatingServiceNegative) * 100), 0)_"%*)"					  
								  
		}
		else 
		{
			set serviceText = $case(var,
								  1:"не понравилось рзнообразие и качество услуг",
								  2:"отметили невысокий уровень сервиса",
								  3:"остались недовольны качеством услуг",
								  4:"низко оценили качество предоставляемых услуг",
								  5:"низко оценили уровень сервиса",
								  6:"отрицательно оценили качество сервиса")
								  
			set serviceText = serviceText_" - "_iKnowRatingServiceNegative_" ("_$NORMALIZE((iKnowRatingServiceNegative / (iKnowRatingServicePositive + iKnowRatingServiceNegative) * 100), 0)_"%*)"								  
		}	
	}	
	
	set var = $random(2) + 1
	
	set extraText = $case(var, 1:" А красивых рыбок никто не оценил, потому что мы о них не спрашивали.",
							   2:" Не забудьте перед поездкой запастись кремом для загара.")
							   
	set var = $random(5) + 1	
	
	if (var '= 1) { set extraText = ""}
	
	set finalText = finalText_comfortText_foodText_hospitalityText_serviceText_"."_extraText
	
	return finalText
}*/
/// The method of obtaining the final phrase about the phone.
/// phoneId - Phone ID
Storage Default
{
<Data name="PhoneDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PhoneId</Value>
</Value>
<Value name="3">
<Value>PhoneName</Value>
</Value>
<Value name="4">
<Value>UserRating</Value>
</Value>
<Value name="5">
<Value>iKnowRating</Value>
</Value>
<Value name="6">
<Value>iKnowEmarkersRating</Value>
</Value>
<Value name="7">
<Value>iKnowRatingComfort</Value>
</Value>
<Value name="8">
<Value>iKnowRatingPerfomance</Value>
</Value>
<Value name="9">
<Value>iKnowRatingLink</Value>
</Value>
<Value name="10">
<Value>iKnowRatingCamera</Value>
</Value>
<Value name="11">
<Value>ReviewsCount</Value>
</Value>
<Value name="12">
<Value>NegativeReviewsPCT</Value>
</Value>
<Value name="13">
<Value>PositiveReviewsPCT</Value>
</Value>
<Value name="14">
<Value>NeutralReviewsPCT</Value>
</Value>
<Value name="15">
<Value>SentComfort</Value>
</Value>
<Value name="16">
<Value>SentPerfomance</Value>
</Value>
<Value name="17">
<Value>SentLink</Value>
</Value>
<Value name="18">
<Value>SentCamera</Value>
</Value>
</Data>
<DataLocation>^ikra.Phones.Stat.PhoneD</DataLocation>
<DefaultData>PhoneDefaultData</DefaultData>
<Description>
<![CDATA[The method of obtaining the final phrase about the phone.
phoneId - Phone ID]]></Description>
<IdLocation>^ikra.Phones.Stat.PhoneD</IdLocation>
<IndexLocation>^ikra.Phones.Stat.PhoneI</IndexLocation>
<StreamLocation>^ikra.Phones.Stat.PhoneS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

