#include <stdlib.h>
#include <stdio.h>
#include <windows.h>
#include <string.h>

#define LARGEUR 256
#define HAUTEUR 256
#define DISPLAYTOOL "displayTool\\display.exe"
#define MEDIAN 5

// Fonction de comparaison, utilisée dans la fonction qsort pour le tri du
// tableau pour la méthode MEDIAN
int compare( const void* a, const void* b )
{
	unsigned char aa, bb;
	aa = *(unsigned char*)a;
	bb = *(unsigned char*)b;

	if( aa>bb )
		return 1;
	else if( aa<bb )
		return -1;
	return 0;
}

int main(void)
{
	//--------------------------------------------------
	// Déclaration des variables
	//--------------------------------------------------
	unsigned char image[LARGEUR][HAUTEUR];	// la matrice de l'image originale
	unsigned char image2[LARGEUR][HAUTEUR];	// la matrice de l'image originale
	unsigned char imageT[LARGEUR][HAUTEUR];	// la matrice de l'image après traitement
	unsigned char imageC[LARGEUR*3][HAUTEUR];        // la matrice de l'image après
	char nomFichier[] = "images\\lena.raw"; // le nom du fichier image à lire
	char nomFichier2[] = "images\\mesange.raw";	     // le nom du fichier image à lire
	char nomFichierT[] = "images\\res.raw";	         // le nom du fichier image à écrire
	//char nomFichierT2[] = "images\\res.bmp";	         // le nom du fichier image couleur à écrire
	char nomFichierC[] = "images\\lena.bmp";	// le nom du fichier image couleur
	int x, y, i, j;							// variables d'itération
	FILE* fichier;							// la variable fichier
	int pixel;					            // variable tampon
	float fpixel;							// variable tampon float
	int histogramme[256];					// l'histogramme
	int n;									// indice de tableau pour le filtre médian
	unsigned char median[MEDIAN*MEDIAN];	// tableau pour le filtre médian
	char str[256];							// Variable texte temporaire
    int a;

	printf( "\n----------[ DEBUT DU PROGRAMME ]----------\n" );

	//--------------------------------------------------
	// Lecture du ou des fichier(s)
	//--------------------------------------------------
	// Image 1 (la plus couramment utilisée)
	fichier = fopen( nomFichier, "rb" );	// ouverture du fichier en lecture binaire
	if( fichier==0 )
	{	// Erreur d'ouverture
		printf( "Desole, mais le fichier est introuvable ! Le programme va s'arreter..." );
		return 1;
	}
	printf( ">> Lecture de l'image \"%s\" [", nomFichier );
	for( y=0; y<HAUTEUR; y++ )
	{	// lecture sur l'axe Y
		printf( "." );
		for( x=0; x<LARGEUR; x++ )
		{	// lecture sur l'axe X (=lecture d'une ligne)
			image[x][y] = fgetc(fichier);
		}
	}
	fclose(fichier);	// fermeture du fichier
	printf( "]\n>> Lecture de l'image terminee !\n" );

	// Image 2 (pour les traitements nécessitant deux images)
	fichier = fopen( nomFichier2, "rb" );	// ouverture du fichier en lecture binaire
	if( fichier==0 )
	{	// Erreur d'ouverture
		printf( "Desole, mais le fichier est introuvable ! Le programme va s'arreter..." );
		return 1;
	}
	printf( ">> Lecture de l'image \"%s\" [", nomFichier2 );
	for( y=0; y<HAUTEUR; y++ )
	{	// lecture sur l'axe Y
		printf( "." );
		for( x=0; x<LARGEUR; x++ )
		{	// lecture sur l'axe X (=lecture d'une ligne)
			image2[x][y] = fgetc(fichier);
		}
	}
	fclose(fichier);	// fermeture du fichier
	printf( "]\n>> Lecture de l'image terminee !\n" );


	// Lecture image couleur (pour les traitements sur image couleur)
	fichier = fopen( nomFichierC, "rb" );	// ouverture du fichier en lecture binaire
	if( fichier==0 )
	{	// Erreur d'ouverture
		printf( "Desole, mais le fichier est introuvable ! Le programme va s'arreter..." );
		return 1;
	}
	printf( ">> Lecture de l'image \"%s\" [", nomFichierC );
	for( y=0; y<HAUTEUR; y++ )
	{	// lecture sur l'axe Y
		printf( "." );
		for( x=0; x<LARGEUR*3; x++ )
		{	// lecture sur l'axe X (=lecture d'une ligne)
			imageC[x][y] = fgetc(fichier);
		}
	}
	fclose(fichier);	// fermeture du fichier
	printf( "]\n>> Lecture de l'image terminee !\n" );

    //--------------------------------------------------
    // Traitement(s)
    //--------------------------------------------------
    printf( "\n>> Traitement en cours...\n" );

	do{
		printf ("1.Recopie\n");
		printf ("2.Miroir\n");
		printf ("3.Inversement\n");
		printf ("4.Negatif\n");
		printf ("5.Luminosite\n");
		printf ("6.Seuillage\n");
		printf ("7.Contraste\n");
		printf ("8.Conversion en niveaux de gris\n");
		printf ("9.Filtrage median\n");
		printf ("10.Filtrages contours\n");
		printf ("11.Superposition\n");
		printf ("12.Histogramme\n");
		printf ("0.Quitter\n\n");
		printf ("donner svp le numero du traitement a effectuer : ");
		scanf ("%d", &a);

		if ( a == 1)
		{
			printf ("Recopie : \n");
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ )
			imageT[x][y] = image[x][y];    
			printf( ">> Traitement termine...\n\n" );
		//--------------------------------------------------
		// Ecriture de l'image de résultat
		//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
	
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		////////////////////////////////////////////
		if ( a == 2)
		{
			printf ("Miroir : \n");
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ )
			imageT[x][y] = image[LARGEUR-x-1][y];
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire	
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			printf( "\n----------[ FIN DU PROGRAMME ]----------\n" );

			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		//////////////////////////////////////////////////////////////////////////
		if ( a == 3)
		{
			printf ("Inversement : \n");
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ )
			imageT[x][y] = image[x][HAUTEUR-y-1]; 
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
	
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		///////////////////////////////////////////////////////////////////////////
		if ( a == 4)
		{
			printf ("Negatif : \n");
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ )
			imageT[x][y] = 255-image[x][y]; 
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
	
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}	
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		//////////////////////////////////////////////////////////////////////////////  
		if ( a == 5)
		{
			printf ("Luminosite : \n");
			//(exemple, +50)
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ ) 
			{
				pixel = image[x][y]+50;
				if( pixel > 255)
					pixel = 255;
				else if( pixel < 0)
					pixel = 0;
					imageT[x][y] = pixel;
			} 
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
	
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );
	
			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		///////////////////////////////////////////////////////////////////////
		if ( a == 6)
		{
			printf ("Seuillage : \n");
			//(exemple, valeur de seuillage=147)
			for( y=0; y<HAUTEUR; y++ )
			{
				for( x=0; x<LARGEUR; x++ )
				{
					if(image[x][y]>=147)
						pixel = 255 ;
					else
						pixel = 0 ;
					imageT[x][y] = pixel;
				}
			} 
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
		
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			// Affichage du résultat et de l'image originale	
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		////////////////////////////////////////////////////////////////////////////
		if ( a == 7)
		{
			printf ("Contraste : \n");
			//(exemple, contraste de 5. Remarque, on peut également jouer sur la valeur de seuil=128)
			for( y=0; y<HAUTEUR; y++ )
			{
				for( x=0; x<LARGEUR; x++ )
				{
					//calcul de la valeur contrastée
					fpixel = ((float)image[x][y]-128.0f)*5.0f+128.0f; 
					// on vérifie que la valeur obtenue est bien dans [0..255]
					if( fpixel>255 )
						fpixel = 255.0f;
					else if( fpixel<0 )
						fpixel = 0.0f;
						imageT[x][y] = (unsigned char)fpixel;
				}
			}
			printf( ">> Traitement termine...\n\n" );
			//-------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
		
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );
			
			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		/////////////////////////////////////////////////////////////////////////////  
		if ( a == 8)
		{	
			printf ("Conversion en niveaux de gris : \n");
			//conversion en utilisant les canaux R, V et B
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ )
				imageT[x][y] = (imageC[x*3][y] + imageC[x*3+1][y] + imageC[x*3+2][y])/3;

			// récupération du canal V, par exemple
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ )
				imageT[x][y] = imageC[x*3+1][y]; 
				printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
		
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT);
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}	
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichierC, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		//////////////////////////////////////////////////////////////////////////////////  
		if ( a == 9)
		{
			printf ("Filtrage médian : \n");	
			//(calcul du médian pour une taille variable, contenue dans MEDIAN)
			int num = MEDIAN/2;
			for( y=num; y<HAUTEUR-num; y++ )
			{
				for( x=num; x<LARGEUR-num; x++ )
				{
					n=0;
					// (1) création de la liste des valeurs de la zone d'intérêt
					for( j=y-num; j<y+num+1; j++ )
					for( i=x-num; i<x+num+1; i++ )
						median[n++] = image[i][j];
						// (2) tri du tableau de la zone d'intérêt
						qsort( median, MEDIAN*MEDIAN, sizeof(unsigned char), compare );
						// (3) affectation de la valeur médiane du tableau
						imageT[x][y] = median[MEDIAN*MEDIAN/2];
				}
			}
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
		
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );
			
			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		/////////////////////////////////////////////////////////////////////////////////  
		if ( a == 10)
		{
			printf ("Filtrages contours : \n");
			//(exemple, filtrage Laplacien. Modifier les multiplicateurs pour les autres)
			for( y=1; y<HAUTEUR-1; y++ )
			{
				for( x=1; x<LARGEUR-1; x++ )
				{
					// calcul de la valeur
					pixel = (image[x-1][y-1]*-1 + image[x][y-1]*-1 + 
					image[x+1][y-1]*-1 + image[x-1][y]*-1 + 
					image[x][y]*8 + image[x+1][y]*-1 +
					image[x-1][y+1]*-1 + image[x][y+1]*-1 + 
					image[x+1][y+1]*-1)/3+127;
					if( pixel>255 )
						pixel = 255.0f;
					else if( pixel<0 )
						pixel = 0.0f;
						imageT[x][y] = pixel;
				}
			}
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire
		
			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
		///////////////////////////////////////////////////////////////////////////////////////
		if ( a == 11)
		{
			printf ("Superposition : \n");
			// (1) Addition des deux images
			for( y=0; y<HAUTEUR; y++ )
			for( x=0; x<LARGEUR; x++ )
				imageT[x][y] = (image[x][y]+image2[x][y])/2;

			// (2) Superposition, en prenant le niveau 220 de l'image2 comme transparence
			for( y=0; y<HAUTEUR; y++ )
			{
				for( x=0; x<LARGEUR; x++ )
				{
					if( image2[x][y]==220 )
						pixel = image[x][y];
					else
						pixel = image2[x][y];
					imageT[x][y] = pixel;
				}
			}
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire

			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );

			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT); 
		}
		////////////////////////////////////////////////////////////////////////////////////
		if ( a == 12)
		{	
			printf ("Histogramme : \n");
			for( i=0; i<256; i++ ) // initialisation à 0 de l'histogramme
			histogramme[i] = 0;

			for( y=0; y<HAUTEUR; y++ ) // initialisation à 0 de l'image cible
			for( x=0; x<LARGEUR; x++ )
				imageT[x][y] = 0;

			for( y=0; y<HAUTEUR; y++ )
			{
				for( x=0; x<LARGEUR; x++ )
				{
					// incrémentation de la valeur du pixel correspondant à son niveau
					histogramme[image[x][y]]++;
					// affectation dans l'image traitée, de la valeur
					// courante, au niveau du pixel sur l'axe X
					imageT[image[x][y]][histogramme[image[x][y]]] = image[x][y];
				}
			} 
			printf( ">> Traitement termine...\n\n" );
			//--------------------------------------------------
			// Ecriture de l'image de résultat
			//--------------------------------------------------
			fichier = fopen( nomFichierT, "w+b" );	// ouverture du fichier en écriture binaire

			if( fichier==0 )
			{	// Erreur d'ouverture
				printf( "Desole, mais le fichier ne peut etre ouvert en ecriture..." );
				return 1;
			}

			printf( ">> Ecriture de l'image \"%s\" [", nomFichierT );
			for( y=0; y<HAUTEUR; y++ )
			{	// Ecriture sur l'axe Y
				printf( "." );
				for( x=0; x<LARGEUR; x++ )
				{	// Ecriture sur l'axe X (ecriture d'une ligne)
					pixel = imageT[x][y];
					fputc(pixel, fichier);
				}
			}
			fclose( fichier );
			printf( "]\n>> Ecriture de l'image terminee !\n" );
			// Affichage du résultat et de l'image originale
			sprintf( str, "\"%s\" -%d -%d", nomFichier, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
			sprintf( str, "\"%s\" -%d -%d", nomFichierT, LARGEUR, HAUTEUR );
			ShellExecute(NULL, "open", DISPLAYTOOL, str, NULL, SW_SHOWDEFAULT);
		}
	}while(a != 0);
}
