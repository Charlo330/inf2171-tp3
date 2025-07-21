# TP2 - Automate cellulaire
# Charles-Antoine Lanthier LANC70040208 (groupe 050)
.eqv sBreak, 9

.global newP
.global mGen
.global addEnf
.global printLignePere
.global sizeArbre

.text

#
# IN: a0 - année naissance
#     a1 - adresse père
#     a2 - adresse mère 
# OUT: a0 - adresse du nouveau noeud personne  / 0 en cas d'erreur
newP:
# prologue
addi sp, sp, -32      # On descend le stack pointer de 32 octets
sd s0, 0(sp)          # On sauvegarde s0 à l'adresse sp
sd s1, 8(sp)          # s1 à sp + 8
sd s2, 16(sp)         # s2 à sp + 16
sd s3, 24(sp)         # s3 à sp + 24

# allocation 32 oct tas
mv s0, a0 # année naissance
mv s1, a1 # adresse père
mv s2, a2 # adresse mère

# allocation 32 octets
li a0, 32
li a7, sBreak
ecall
mv s3, a0 # adresse noeud

# stocker en mémoire
sd s1, 0(s3) 	# adresse père
sd s2, 8(s3) 	# adresse mère
sd s0, 16(s3)	# annee naissance
sd zero, 24(s3) # addresse liste enfant

# retourner addr noeud
mv a0, s3

# épilogue
ld s0, 0(sp)          # On recharge les valeurs dans les registres
ld s1, 8(sp)
ld s2, 16(sp)
ld s3, 24(sp)
addi sp, sp, 32

ret

#
# IN: addr noeud Personne
# OUT: niveau generation
mGen:
# prologue
addi sp, sp, -48
sd s0, 0(sp)
sd ra, 8(sp)
sd s1, 16(sp)
sd s2, 24(sp)
sd s3, 32 (sp)
sd s4, 40(sp)

# garder adresse personne
mv s0, a0

# si personne = null, ret 0
beqz s0, niv0

# charger père
ld s1, 0(a0)

# charger mère
ld s2, 8(a0)

# si père & mère null, ret 1
bnez s1, continue

bnez s2, continue

j niv1

continue:
# calc père
mv a0, s1
call mGen
mv s3, a0

# calc mère
mv a0, s2
call mGen
mv s4, a0 
# si père > mère, on garde père si non mère et on récursive
bgt s4, s3, merePlusGrande
# père plus grand
mv a0, s3
addi a0, a0, 1
j fin

merePlusGrande:
mv a0, s4
addi a0, a0, 1
j fin

niv0:
li a0, 0
j fin

niv1:
li a0, 1

fin:
# épilogue
ld s0, 0(sp)
ld ra, 8(sp)
ld s1, 16(sp)
ld s2, 24(sp)
ld s3, 32(sp)
ld s4, 40(sp)
addi sp, sp, 48

ret

printLignePere:
# prologue
addi sp, sp, -24
sd ra, 0(sp)
sd s1, 8(sp)
sd s2, 16(sp)

# si père a0 = null fin print
ld s1, 0(a0)

mv s2, ra
ld a0, 16(a0) # annee courant
call printInt
mv ra, s2

beqz s1, finPrint

li a0, ' ' # print espace
mv s2, ra
call printChar
mv ra, s2

mv a0, s1
call printLignePere

j epilogue

finPrint:
	li a0, ' '
	mv s2, ra
	call printChar
	mv ra, s2
	
	li a0, '\n'
	mv s2, ra
	call printChar
	mv ra, s2
	# épilogue
	epilogue:
	ld ra, 0(sp)
	ld s1, 8(sp)
	ld s2, 16(sp)
	addi sp, sp, 24
	
    ret 




#
# IN - a0 addr enfant
# IN - a1 addr parent
addEnf:
# prologue
addi sp, sp, -24
sd s0, 0(sp)
sd s1, 8(sp)
sd s2, 16(sp)

# si pas parent erreur

beqz a0, errAddEnf
beqz a1, errAddEnf

# si pas enfant erreur

mv s0, a0 # adresse enfant à ajouter
mv s1, a1 # adresse père
ld t1, 24(s1) # adresse maillon premier enfant 
li s2, 0	# adresse maillon precedent

beqz t1, creerMaillon

loopAddEnf:
ld t0, 8(t1)
beqz t0, ajouterMaillon
mv s2, t1 # precedent = courant
j loopAddEnf

creerMaillon:
li a0, 24
li a7, sBreak
ecall

sd s0, 0(a0)
sd zero, 8(a0)
sd zero, 16(a0)

sd a0, 24(s1)
li a0, 1
j sortieAddEnf

ajouterMaillon:
li a0, 24
li a7, sBreak
ecall

sd s0, 0(a0)
sd zero, 8(a0)
sd s2, 16(a0)

# store suivant
sd a0, 8(t1)

li a0, 1
j sortieAddEnf

# si enfant = null

errAddEnf:
li a0, 1

sortieAddEnf:
ld s0, 0(sp)
sd s1, 8(sp)
sd s2, 16(sp)
addi sp, sp, 24


ret


#
# IN : a0 - adresse noeud personne
# OUT: a0 - nb total descendant
sizeArbre:
# prologue
sd ra, 0(sp)


