//species checks
#define isdiona(A) (is_species(A, /datum/species/diona))
#define isdwarf(A) (is_species(A, /datum/species/dwarf))
#define islavalanddwarf(A) (is_species(A, /datum/species/dwarf/lavaland))
#define isskaven(A) (is_species(A, /datum/species/skaven))
#define iskitsune(A) (is_species(A, /datum/species/human/kitsune))
#define iskobold(A) (is_species(A, /datum/species/kobold))
#define ismountaindwarf(A) (is_species(A, /datum/species/dwarf/mountain))
#define ischaosdwarf(A) (is_species(A, /datum/species/dwarf/chaos))
#define isdwarftype(A) (is_species(A, /datum/species/dwarf) || is_species(A, /datum/species/dwarf/lavaland) || is_species(A, /datum/species/dwarf/mountain) || is_species(A, /datum/species/dwarf/chaos))
// mod suit check
#define ismodboots(A) (istype(A, /obj/item/clothing/shoes/mod))
