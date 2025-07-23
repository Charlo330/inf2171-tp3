# TP3 - Abre genealogique
# Charles-Antoine Lanthier LANC70040208 (groupe 050)
# Tous les tests sont fonctionnels

.eqv sBreak, 9

.global newP
.global mGen
.global addEnf
.global printLignePere
.global sizeArbre

.text

# Routine ajoutant une nouvelle personne
# IN: a0 - année naissance
#     a1 - adresse pere
#     a2 - adresse mere 
# OUT: a0 - adresse du nouveau noeud personne  / 0 en cas d'erreur
newP:

	# prologue
	addi sp, sp, -32
	sd s0, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	sd s3, 24(sp)
	
	mv s0, a0 			# annee naissance
	mv s1, a1 			# adresse pere
	mv s2, a2 			# adresse mere
	
	# allocation 32 octets tas
	li a0, 32
	li a7, sBreak
	ecall
	
	beqz a0, erreurNewP # a0 == 0, erreur allocation
	mv s3, a0 			# adresse noeud
	
	# stocker en memoire
	sd s1, 0(s3) 		# adresse pere
	sd s2, 8(s3) 		# adresse mere
	sd s0, 16(s3)		# annee naissance
	sd zero, 24(s3) 	# addresse liste enfant
	
	# retourner addr noeud
	mv a0, s3
	
	j epilogueNewP

# gestion erreurs de la routine
erreurNewP:
	li a0, 0

# epilogue
epilogueNewP:
	ld s0, 0(sp)    	# On recharge les valeurs dans les registres
	ld s1, 8(sp)
	ld s2, 16(sp)
	ld s3, 24(sp)
	addi sp, sp, 32
	
	ret

# Routine calculant le niveau de generation d'une personne
# IN: a0 - addr noeud Personne
# OUT: a0 - niveau generation
mGen:
	# prologue
	addi sp, sp, -48
	sd s0, 0(sp)
	sd ra, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	sd s3, 32 (sp)
	sd s4, 40(sp)
	
	mv s0, a0 # adresse personne
	
	beqz s0, niv0 # personne == null
	
	# charger pere
	ld s1, 0(a0)
	
	# charger mere
	ld s2, 8(a0)
	
	# si pere & mere null, ret 1
	bnez s1, continuer
	bnez s2, continuer
	
	j niv1

# etiquette permettant de continuer la routine
continuer:
	# calculer niv generation pere
	mv a0, s1
	call mGen
	mv s3, a0 # niveau generation pere
	
	# calculer niv generation mere
	mv a0, s2
	call mGen
	mv s4, a0 # niveau generation mere
	
	bgt s4, s3, merePlusGrande # niv pere > mere
	
	# pere plus grand
	mv a0, s3
	addi a0, a0, 1 # ajoute 1 niv generation personne courante
	j finMGen

# cas ou la mere > pere
merePlusGrande:
	mv a0, s4
	addi a0, a0, 1 # ajoute 1 niv generation personne courante
	j finMGen

# retourner le niv generation 0
niv0:
	li a0, 0
	j finMGen

# retourner niv generation 1
niv1:
	li a0, 1

# epilogue
finMGen:
	ld s0, 0(sp)
	ld ra, 8(sp)
	ld s1, 16(sp)
	ld s2, 24(sp)
	ld s3, 32(sp)
	ld s4, 40(sp)
	addi sp, sp, 48
	
	ret

# Routine imprimant les annees de naissances de la lignee paternelle
# IN: a0 - adresse noeud enfant
printLignePere:
	# prologue
	addi sp, sp, -24
	sd ra, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	
	ld s1, 0(a0) 		# adresse pere
	
	# impression annee courante
	ld a0, 16(a0) 		# load annee courante
	call printInt
	
	beqz s1, finPrint 	# s1 == 0
	
	# impression caractere espace
	li a0, ' '
	call printChar
	
	# appel recursif pere
	mv a0, s1
	call printLignePere
	
	j epilogue
	
# gestion du print final
finPrint:
	li a0, ' '
	call printChar
	
	li a0, '\n'
	call printChar

# epilogue
epilogue:
	ld ra, 0(sp)
	ld s1, 8(sp)
	ld s2, 16(sp)
	addi sp, sp, 24
	
    ret 

# Routine ajoutant un enfant
# IN - a0 addr enfant
# 	   a1 addr parent
# OUT - a0 1 = succes, 0 = erreur
addEnf:
	# prologue
	addi sp, sp, -24
	sd s0, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	
	# pas parent, erreur
	beqz a0, errAddEnf
	beqz a1, errAddEnf
	
	mv s0, a0 				# adresse enfant à ajouter
	mv s1, a1				# adresse pere
	ld t1, 24(s1) 			# adresse maillon premier enfant 
	li s2, 0				# adresse maillon precedent
	
	beqz t1, creerMaillon 	# t1 == 0

# boucle se rendant au dernier enfant du parent
boucleAddEnf:
	ld t0, 8(t1)			# load du maillon de l'enfant suivant
	beqz t0, ajouterMaillon # t0 == 0
	mv s2, t1 				# precedent = courant
	j boucleAddEnf

# gestion de la creation d'un maillon lorsque le parent n'a pas d'enfant
creerMaillon:
	# alocation de 24 octets dans le tas
	li a0, 24
	li a7, sBreak
	ecall

	# enregistrement des valeurs dans le maillon
	sd s0, 0(a0)	# adresse enfant
	sd zero, 8(a0)	# adresse enfant suivant
	sd zero, 16(a0) # adresse enfant precedent
	
	sd a0, 24(s1)
	li a0, 1
	j sortieAddEnf
	
# gestion de l'ajout d'un maillon enfant dans la liste
ajouterMaillon:
	# alocation de 24 octets dans le tas
	li a0, 24
	li a7, sBreak
	ecall

	# enregistrement des valeurs dans le nouveau maillon
	sd s0, 0(a0)	# adresse enfant
	sd zero, 8(a0)	# adresse enfant suivant
	sd s2, 16(a0)	# adresse enfant precedent

	# ajout adresse nouv maillon sur dernier maillon
	sd a0, 8(t1)
	
	li a0, 1 		# succes
	j sortieAddEnf

# gestion des erreurs de la routine addEnf
errAddEnf:
	li a0, 1

# epilogue routine addEnf
sortieAddEnf:
	ld s0, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	addi sp, sp, 24
	
	ret


# Routine calculant le nombre de descendants d'une personne
# IN : a0 - adresse noeud personne
# OUT: a0 - nb total descendant
sizeArbre:
	# prologue
	addi sp, sp, -24
	sd ra, 0(sp)
	sd s1, 8(sp)
	sd s2, 16(sp)
	
	li s2, 0 # total descendants
	
	beqz a0, finBoucleSizeArbre # si enfant = null
	
	ld s1, 24(a0) # noeud linked list courant

# boucle iterant aux travers de chaques enfants de la personne
boucleEnfants:
	# charger noeud enfant
	beqz s1, finBoucleSizeArbre # s1 == 0
	addi s2, s2, 1 				# ajout enfant au total
	ld t1, 0(s1) 				# noeud enfant
	
	# appel recursif pour avoir le nb de descendants de la personne
	mv a0, t1
	call sizeArbre
	add s2, s2, a0 				# nb total descendants + nb descendants personne
	
	ld s1, 8(s1)				# load enfant suivant
	
	j boucleEnfants

# fin de l'iteration
finBoucleSizeArbre:
	mv a0, s2 # retourne nb enfants

# epilogue
epilogueSizeArbre:
	ld ra, 0(sp)
	ld s1, 8(sp)
	ld s2, 16(sp)
	addi sp, sp, 24
	ret

