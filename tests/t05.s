# Test t05.s - Test de la routine printLignePere avec allocation dynamique

.data

    # Variables pour stocker les adresses des personnes créées
    addr_grandpere: .dword 0
    addr_pere: .dword 0
    addr_mere: .dword 0
    addr_enfant1: .dword 0
    addr_enfant2: .dword 0

.text

    # Créer la famille avec allocation dynamique

    # Créer le grand-père (pas de parents)
    li a0, 1950     # année de naissance
    li a1, 0        # pas de père
    li a2, 0        # pas de mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_grandpere
    sd a0, 0(t0)    # Sauvegarder l'adresse du grand-père

    # Créer la mère (pas de parents)
    li a0, 1978     # année de naissance
    li a1, 0        # pas de père
    li a2, 0        # pas de mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_mere
    sd a0, 0(t0)    # Sauvegarder l'adresse de la mère

    # Créer le père (grand-père comme père)
    li a0, 1975     # année de naissance
    la t0, addr_grandpere
    ld a1, 0(t0)    # père = grand-père
    li a2, 0        # pas de mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_pere
    sd a0, 0(t0)    # Sauvegarder l'adresse du père

    # Créer l'enfant1 (père et mère)
    li a0, 2000     # année de naissance
    la t0, addr_pere
    ld a1, 0(t0)    # père
    la t0, addr_mere
    ld a2, 0(t0)    # mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_enfant1
    sd a0, 0(t0)    # Sauvegarder l'adresse de l'enfant1

    # Créer l'enfant2 (père et mère)
    li a0, 2005     # année de naissance
    la t0, addr_pere
    ld a1, 0(t0)    # père
    la t0, addr_mere
    ld a2, 0(t0)    # mère
    jal newP
    beq a0, zero, creation_fail
    la t0, addr_enfant2
    sd a0, 0(t0)    # Sauvegarder l'adresse de l'enfant2

    # Établir les relations parent-enfant avec addEnf

    # Ajouter le père comme enfant du grand-père
    la t0, addr_pere
    ld a0, 0(t0)        # adresse du père
    la t0, addr_grandpere
    ld a1, 0(t0)        # adresse du grand-père
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant1 comme enfant du père
    la t0, addr_enfant1
    ld a0, 0(t0)        # adresse de l'enfant1
    la t0, addr_pere
    ld a1, 0(t0)        # adresse du père
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant2 comme enfant du père
    la t0, addr_enfant2
    ld a0, 0(t0)        # adresse de l'enfant2
    la t0, addr_pere
    ld a1, 0(t0)        # adresse du père
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant1 comme enfant de la mère
    la t0, addr_enfant1
    ld a0, 0(t0)        # adresse de l'enfant1
    la t0, addr_mere
    ld a1, 0(t0)        # adresse de la mère
    jal addEnf
    beq a0, zero, creation_fail

    # Ajouter enfant2 comme enfant de la mère
    la t0, addr_enfant2
    ld a0, 0(t0)        # adresse de l'enfant2
    la t0, addr_mere
    ld a1, 0(t0)        # adresse de la mère
    jal addEnf
    beq a0, zero, creation_fail

    # Test 1: Lignée paternelle du grand-père
    la t0, addr_grandpere
    ld a0, 0(t0)
    jal printLignePere
    # Sortie attendue: "1950 " suivi d'un newline

    # Test 2: Lignée paternelle du père
    la t0, addr_pere
    ld a0, 0(t0)
    jal printLignePere
    # Sortie attendue: "1975 1950 " suivi d'un newline

    # Test 3: Lignée paternelle de la mère
    la t0, addr_mere
    ld a0, 0(t0)
    jal printLignePere
    # Sortie attendue: "1978 " suivi d'un newline

    # Test 4: Lignée paternelle de l'enfant1
    la t0, addr_enfant1
    ld a0, 0(t0)
    jal printLignePere
    # Sortie attendue: "2000 1975 1950 " suivi d'un newline

    # Test 5: Lignée paternelle de l'enfant2
    la t0, addr_enfant2
    ld a0, 0(t0)
    jal printLignePere
    # Sortie attendue: "2005 1975 1950 " suivi d'un newline

    # Test 6: Test avec paramètre NULL
    li a0, 0
    jal printLignePere
    # Sortie attendue: rien (fonction doit gérer NULL proprement)

    # Fin du programme
    li a7, 10                   # Exit
    ecall

creation_fail:
    li a7, 10                   # Exit
    ecall

#stdout:1950 \n1975 1950 \n1978 \n2000 1975 1950 \n2005 1975 1950
