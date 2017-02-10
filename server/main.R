{
	shinyjs::addClass(id = 'menus', class = "navbar-right")

    observeEvent(techSelected(), {
      	
    	if(techSelected() == 'nothing')
    	{
    		shinyjs::hide(selector=".navbar li")
    		shinyjs::show(selector=".navbar li:nth-child(1)")
    	}	 
    	else
    	{

	      	#setting the childNum 
	      	switch(techSelected(),
		      	"linear"={
		      		childNum <- "5"
		      		de_childNum <- "2"
		      		de_selected <- gsub(" ","",paste("de","_linear"))
		      		inFile <- input$file
		      	},
		      	"logistic"={
		      		childNum <- "6"
		      	},
		      	"naive"={
		      		childNum <- "7"
		      	},
		      	"neural"={
		      		childNum <- "8"
		      	},
		      	"decision"={
		      		childNum <- "9"
		      	},
		      	"k-nearest"={
		      		childNum <- "10"
		      	},
		      	"SVM"={
		      		childNum <- "11"
		      	},
		      	"forest"={
		      		childNum <- "12"
		      	},
		      	"boosting"={
		      		childNum <- "13"
		      	}
	      	)

	      	#setting the selector
	      	pickmenu <- "li:nth-child("
	      	pickmenu <- paste(pickmenu, childNum,")")
	      	pickmenu <- gsub(" ","", pickmenu)
	      	pickmenu <- paste(".navbar", pickmenu)

	      	# de_selector
	      	pick_demenu <- "li:nth-child("
	      	pick_demenu <- paste(pick_demenu, de_childNum,")")
	      	pick_demenu <- gsub(" ", "", pick_demenu)
	      	pick_demenu <- paste(".navbar", pick_demenu)


	      	# go to the seleted page. 
	      	if(is.null(inFile)){
	      		shinyjs::hide(selector=".navbar li")
    			shinyjs::show(selector=".navbar li:nth-child(1)")
    			shinyjs::show(selector = pick_demenu)
	      		shinyjs::show(selector= pickmenu)
	      		updateNavbarPage(session, "menus", selected = de_selected)
	      	}
	      	else{
	      		shinyjs::hide(selector=".navbar li")
    			shinyjs::show(selector=".navbar li:nth-child(1)")
    			shinyjs::show(selector = pick_demenu)
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
    	}	 
    	else
    	{

	      	#setting the childNum 
	      	switch(techSelected2(),
		      	"Arules"={
		      		childNum <- "14"
		      		de_childNum <- "3"
		      		de_selected <- gsub(" ","",paste("de","_arules"))
		      		inFile <- input$file2 
		      	},
		      	"k-means"={
		      		childNum <- "15"
		      	},
		      	"PCA"={
		      		childNum <- "16"
		      		de_childNum <- "4"
		      		de_selected <- gsub(" ","",paste("de","_pca"))
		      		inFile <- input$file3
		      	}
	      	)

	      	#setting the selector
	      	pickmenu <- "li:nth-child("
	      	pickmenu <- paste(pickmenu, childNum,")")
	      	pickmenu <- gsub(" ","", pickmenu)
	      	pickmenu <- paste(".navbar", pickmenu)
	      	# de_selector
	      	pick_demenu <- "li:nth-child("
	      	pick_demenu <- paste(pick_demenu, de_childNum,")")
	      	pick_demenu <- gsub(" ", "", pick_demenu)
	      	pick_demenu <- paste(".navbar", pick_demenu)

	      	# go to the seleted page. 
	      	if(is.null(inFile)){
	      		shinyjs::hide(selector = ".navbar li")
    			shinyjs::show(selector = ".navbar li:nth-child(1)")
    			shinyjs::show(selector = pick_demenu)
	      		shinyjs::show(selector = pickmenu)
	      		updateNavbarPage(session, "menus", selected = de_selected)
	      	}
	      	else{
	      		shinyjs::hide(selector = ".navbar li")
    			shinyjs::show(selector = ".navbar li:nth-child(1)")
    			shinyjs::show(selector = pick_demenu)
	      		shinyjs::show(selector = pickmenu)
	      		updateNavbarPage(session, "menus", selected = techSelected2())
	      	}
	    }
    })

  
}