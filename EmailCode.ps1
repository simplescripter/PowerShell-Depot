write-host ((0..98)| %{if(($_+1)%3 -eq 0){[char][int]("115104097119110046115116117103097114116064102111099097108112111105110116108101097114110046099111109"[($_-2)..$_] -join "")}}) -separator "" 
