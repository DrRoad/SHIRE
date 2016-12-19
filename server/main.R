{
	shinyjs::addClass(id = 'menus', class = "navbar-right")

    observeEvent(techSelected(), {
      	
    	if(techSelected() == 'nothing')
    	{
    		shinyjs::hide(selector=".navbar li")
    		shinyjs::show(selector=".navbar li:nth-child(1)")
    		shinyjs::show(selector=".navbar li:nth-child(2)")
    	}	 
    	else
    	{
	      	inFile <- input$file1 

	      	#setting the childNum 
	      	switch(techSelected(),
		      	"linear"={
		      		childNum <- "3"
		      	},
		      	"logistic"={
		      		childNum <- "4"
		      	},
		      	"naive"={
		      		childNum <- "5"
		      	},
		      	"neural"={
		      		childNum <- "6"
		      	},
		      	"decision"={
		      		childNum <- "7"
		      	},
		      	"k-nearest"={
		      		childNum <- "8"
		      	},
		      	"SVM"={
		      		childNum <- "9"
		      	},
		      	"forest"={
		      		childNum <- "10"
		      	},
		      	"boosting"={
		      		childNum <- "11"
		      	}
	      	)

	      	#setting the selector
	      	pickmenu <- "li:nth-child("
	      	pickmenu <- paste(pickmenu, childNum,")")
	      	pickmenu <- gsub(" ","", pickmenu)
	      	pickmenu <- paste(".navbar", pickmenu)

	      	# go to the seleted page. 
	      	if(is.null(inFile)){
	      		shinyjs::hide(selector=".navbar li")
    			shinyjs::show(selector=".navbar li:nth-child(1)")
    			shinyjs::show(selector=".navbar li:nth-child(2)")
	      		shinyjs::show(selector=pickmenu)
	      		updateNavbarPage(session, "menus", selected = "report")
	      	}
	      	else{
	      		shinyjs::hide(selector=".navbar li")
    			shinyjs::show(selector=".navbar li:nth-child(1)")
    			shinyjs::show(selector=".navbar li:nth-child(2)")
	      		shinyjs::show(selector=pickmenu)
	      		updateNavbarPage(session, "menus", selected = techSelected())
	      	}
	    }
    })



    observeEvent(techSelected2(), {
      	
    	if(techSelected2() == 'nothing')
    	{
    		shinyjs::hide(selector=".navbar li")
    		shinyjs::show(selector=".navbar li:nth-child(1)")
    		shinyjs::show(selector=".navbar li:nth-child(2)")
    	}	 
    	else
    	{
	      	inFile <- input$file1 

	      	#setting the childNum 
	      	switch(techSelected2(),
		      	"Arules"={
		      		childNum <- "12"
		      	},
		      	"k-means"={
		      		childNum <- "13"
		      	},
		      	"PCA"={
		      		childNum <- "14"
		      	}
	      	)

	      	#setting the selector
	      	pickmenu <- "li:nth-child("
	      	pickmenu <- paste(pickmenu, childNum,")")
	      	pickmenu <- gsub(" ","", pickmenu)
	      	pickmenu <- paste(".navbar", pickmenu)

	      	# go to the seleted page. 
	      	if(is.null(inFile)){
	      		shinyjs::hide(selector=".navbar li")
    			shinyjs::show(selector=".navbar li:nth-child(1)")
    			shinyjs::show(selector=".navbar li:nth-child(2)")
	      		shinyjs::show(selector=pickmenu)
	      		updateNavbarPage(session, "menus", selected = "report")
	      	}
	      	else{
	      		shinyjs::hide(selector=".navbar li")
    			shinyjs::show(selector=".navbar li:nth-child(1)")
    			shinyjs::show(selector=".navbar li:nth-child(2)")
	      		shinyjs::show(selector=pickmenu)
	      		updateNavbarPage(session, "menus", selected = techSelected2())
	      	}
	    }
    })

  
}