/**
 * Tomas Brablec (xbrabl04)
 * 4 Dec 2022
 *
 * 2. projekt IZP 2022/23
 * Jednoducha shlukova analyza: 2D nejblizsi soused.
 * Single linkage
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h> // sqrtf
#include <limits.h> // INT_MAX

/*****************************************************************
 * Ladici makra. Vypnout jejich efekt lze definici makra
 * NDEBUG, napr.:
 *   a) pri prekladu argumentem prekladaci -DNDEBUG
 *   b) v souboru (na radek pred #include <assert.h>
 *      #define NDEBUG
 */
#ifdef NDEBUG
#define debug(s)
#define dfmt(s, ...)
#define dint(i)
#define dfloat(f)
#else

// vypise ladici retezec
#define debug(s) printf("- %s\n", s)

// vypise formatovany ladici vystup - pouziti podobne jako printf
#define dfmt(s, ...) printf(" - "__FILE__":%u: "s"\n",__LINE__,__VA_ARGS__)

// vypise ladici informaci o promenne - pouziti dint(identifikator_promenne)
#define dint(i) printf(" - " __FILE__ ":%u: " #i " = %d\n", __LINE__, i)

// vypise ladici informaci o promenne typu float - pouziti
// dfloat(identifikator_promenne)
#define dfloat(f) printf(" - " __FILE__ ":%u: " #f " = %g\n", __LINE__, f)

#endif

/*****************************************************************
 * Deklarace potrebnych datovych typu:
 *
 * TYTO DEKLARACE NEMENTE
 *
 *   struct obj_t - struktura objektu: identifikator a souradnice
 *   struct cluster_t - shluk objektu:
 *      pocet objektu ve shluku,
 *      kapacita shluku (pocet objektu, pro ktere je rezervovano
 *          misto v poli),
 *      ukazatel na pole shluku.
 */

struct obj_t {
    int id;
    float x;
    float y;
};

struct cluster_t {
    int size;
    int capacity;
    struct obj_t *obj;
};

/*****************************************************************
 * Deklarace potrebnych funkci.
 *
 * PROTOTYPY FUNKCI NEMENTE
 *
 * IMPLEMENTUJTE POUZE FUNKCE NA MISTECH OZNACENYCH 'TODO'
 *
 */

/*
 Inicializace shluku 'c'. Alokuje pamet pro cap objektu (kapacitu).
 Ukazatel NULL u pole objektu znamena kapacitu 0.
*/
void init_cluster(struct cluster_t *c, int cap)
{
    assert(c != NULL);
    assert(cap >= 0);

	c->size = 0;
	
	if (cap == 0) {
		c->obj = NULL;
		return;
	}

	c->obj = malloc(cap * sizeof(struct obj_t));

    if (c->obj == NULL)
		c->capacity = 0;
	else
		c->capacity = cap;
}

/*
 Odstraneni vsech objektu shluku a inicializace na prazdny shluk.
 */
void clear_cluster(struct cluster_t *c)
{
	free(c->obj);
	c->size = 0;
	c->capacity = 0;
	c->obj = NULL;
}

/// Chunk of cluster objects. Value recommended for reallocation.
const int CLUSTER_CHUNK = 10;

/*
 Zmena kapacity shluku 'c' na kapacitu 'new_cap'.
 */
struct cluster_t *resize_cluster(struct cluster_t *c, int new_cap)
{
    // TUTO FUNKCI NEMENTE
    assert(c);
    assert(c->capacity >= 0);
    assert(new_cap >= 0);

    if (c->capacity >= new_cap)
        return c;

    size_t size = sizeof(struct obj_t) * new_cap;

    void *arr = realloc(c->obj, size);
    if (arr == NULL)
        return NULL;

    c->obj = (struct obj_t*)arr;
    c->capacity = new_cap;
    return c;
}

/*
 Prida objekt 'obj' na konec shluku 'c'. Rozsiri shluk, pokud se do nej objekt
 nevejde.
 */
void append_cluster(struct cluster_t *c, struct obj_t obj)
{
	if (c->capacity == c->size) {
		if (resize_cluster(c, c->capacity + CLUSTER_CHUNK) == NULL)
			return;
	}

	c->obj[c->size] = obj;
	c->size++;
}

/*
 Seradi objekty ve shluku 'c' vzestupne podle jejich identifikacniho cisla.
 */
void sort_cluster(struct cluster_t *c);

/*
 Do shluku 'c1' prida objekty 'c2'. Shluk 'c1' bude v pripade nutnosti rozsiren.
 Objekty ve shluku 'c1' budou serazeny vzestupne podle identifikacniho cisla.
 Shluk 'c2' bude nezmenen.
 */
void merge_clusters(struct cluster_t *c1, struct cluster_t *c2)
{
    assert(c1 != NULL);
    assert(c2 != NULL);

	if (c1->capacity - c1->size < c2->size) 
	{
		int new_cap = c1->size + c2->size + CLUSTER_CHUNK;
		if (resize_cluster(c1, new_cap) == NULL)
			return;
	}

	for (int i = 0; i < c2->size; i++)
		c1->obj[c1->size + i] = c2->obj[i];

	c1->size += c2->size;

	sort_cluster(c1);
}

/**********************************************************************/
/* Prace s polem shluku */

/*
 Odstrani shluk z pole shluku 'carr'. Pole shluku obsahuje 'narr' polozek
 (shluku). Shluk pro odstraneni se nachazi na indexu 'idx'. Funkce vraci novy
 pocet shluku v poli.
*/
int remove_cluster(struct cluster_t *carr, int narr, int idx)
{
    assert(idx < narr);
    assert(narr > 0);

	clear_cluster(&carr[idx]);

	for (int i = idx; i < narr - 1; i++) 
		carr[i] = carr[i + 1];

    return narr - 1;
}

/*
 Pocita Euklidovskou vzdalenost mezi dvema objekty.
 */
float obj_distance(struct obj_t *o1, struct obj_t *o2)
{
    assert(o1 != NULL);
    assert(o2 != NULL);

	float dx = o2->x - o1->x;
	float dy = o2->y - o1->y;
    return sqrtf(dx * dx + dy * dy);
}

/*
 Pocita vzdalenost dvou shluku.
*/
float cluster_distance(struct cluster_t *c1, struct cluster_t *c2)
{
    assert(c1 != NULL);
    assert(c1->size > 0);
    assert(c2 != NULL);
    assert(c2->size > 0);

    float min = (float)INT_MAX, dist;

	// we compare each object of c1 with each other object from c2
	// using indexes i, j
	for (int i = 0; i < c1->size; i++) {
		for (int j = 0; j < c2->size; j++) {
			dist = obj_distance(c1->obj + i, c2->obj + j);
			if (dist < min)
				min = dist;
		}
	}

	return min;			
}

/*
 Funkce najde dva nejblizsi shluky. V poli shluku 'carr' o velikosti 'narr'
 hleda dva nejblizsi shluky. Nalezene shluky identifikuje jejich indexy v poli
 'carr'. Funkce nalezene shluky (indexy do pole 'carr') uklada do pameti na
 adresu 'c1' resp. 'c2'.
*/
void find_neighbours(struct cluster_t *carr, int narr, int *c1, int *c2)
{
    assert(narr > 0);

	float min = (float)INT_MAX, dist;

	// we compare every cluster to every other cluster what follows it in carr
	// using indexes i, j, where j is always initialized to i + 1 to only compare with
	// clusters on the right side of carr[i]
    for (int i = 0; i < narr; i++) {
		for (int j = i + 1; j < narr; j++) {
			dist = cluster_distance(&carr[i], &carr[j]);
			if (dist < min) {
				min = dist;
				*c1 = i;
				*c2 = j;
			}
		}
	}
}

// pomocna funkce pro razeni shluku
static int obj_sort_compar(const void *a, const void *b)
{
    // TUTO FUNKCI NEMENTE
    const struct obj_t *o1 = (const struct obj_t *)a;
    const struct obj_t *o2 = (const struct obj_t *)b;
    if (o1->id < o2->id) return -1;
    if (o1->id > o2->id) return 1;
    return 0;
}

/*
 Razeni objektu ve shluku vzestupne podle jejich identifikatoru.
*/
void sort_cluster(struct cluster_t *c)
{
    // TUTO FUNKCI NEMENTE
    qsort(c->obj, c->size, sizeof(struct obj_t), &obj_sort_compar);
}

/*
 Tisk shluku 'c' na stdout.
*/
void print_cluster(struct cluster_t *c)
{
    // TUTO FUNKCI NEMENTE
    for (int i = 0; i < c->size; i++)
    {
        if (i) putchar(' ');
        printf("%d[%g,%g]", c->obj[i].id, c->obj[i].x, c->obj[i].y);
    }
    putchar('\n');
}

/*
 Ze souboru 'filename' nacte objekty. Pro kazdy objekt vytvori shluk a ulozi
 jej do pole shluku. Alokuje prostor pro pole vsech shluku a ukazatel na prvni
 polozku pole (ukalazatel na prvni shluk v alokovanem poli) ulozi do pameti,
 kam se odkazuje parametr 'arr'. Funkce vraci pocet nactenych objektu (shluku).
 V pripade nejake chyby uklada do pameti, kam se odkazuje 'arr', hodnotu NULL.
*/
int load_clusters(char *filename, struct cluster_t **arr)
{
    assert(arr != NULL);

    int len;

	*arr = NULL;

	FILE *file = fopen(filename, "r");
	if (file == NULL)
		return 0;

	if (fscanf(file, "count=%d", &len) != 1)
		return 0;
	
	if (len < 1)
		return 0;

	*arr = malloc(len * sizeof(struct cluster_t));
	if (*arr == NULL)
		return 0;

	for (int i = 0; i < len; i++) {
		struct obj_t new_obj;
		
		if (fscanf(file, "%d %g %g", &new_obj.id, &new_obj.x, &new_obj.y) != 3) {
			*arr = NULL;
			return 0;
		}

		struct cluster_t new_cluster;
		init_cluster(&new_cluster, CLUSTER_CHUNK);
		if (new_cluster.obj == NULL) {
			*arr = NULL;
			return 0;
		}
		append_cluster(&new_cluster, new_obj);

		(*arr)[i] = new_cluster;
	}

	fclose(file);
	return len;
}

/*
 Tisk pole shluku. Parametr 'carr' je ukazatel na prvni polozku (shluk).
 Tiskne se prvnich 'narr' shluku.
*/
void print_clusters(struct cluster_t *carr, int narr)
{
    printf("Clusters:\n");
    for (int i = 0; i < narr; i++)
    {
        printf("cluster %d: ", i);
        print_cluster(&carr[i]);
    }
}

int main(int argc, char *argv[])
{
    struct cluster_t *clusters;

	// checking argument count
	if (argc == 1 || argc > 3) {
		fprintf(stderr, "Usage: ./cluster FILENAME [N]\n");
		return EXIT_FAILURE;
	}

	// loading the "final cluster count" argument
	int final_count;
	if (argc == 3)
		final_count = atoi(argv[2]);
	if (argc == 2 || final_count < 1)
		final_count = 1;

	// loading clusters
    int cluster_count = load_clusters(argv[1], &clusters);
	if (clusters == NULL) {
		fprintf(stderr, "Error during loading data.\n");
		return EXIT_FAILURE;
	}

	// merging closest clusters, up to the target count
	while (cluster_count > final_count) {
		int c1, c2;
		find_neighbours(clusters, cluster_count, &c1, &c2);
		merge_clusters(&clusters[c1], &clusters[c2]);
		cluster_count = remove_cluster(clusters, cluster_count, c2);
	}

	print_clusters(clusters, cluster_count);

	// clearing memory
	for (int i = 0; i < cluster_count; i++)
		clear_cluster(&clusters[i]);
	free(clusters);
	
	return 0;
}
