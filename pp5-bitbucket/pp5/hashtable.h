#ifndef _H_hashtable
#define _H_hashtable

#include <map>
#include <string.h>


struct ltstr {
  bool operator()(const char* s1, const char* s2) const
  { return strcmp(s1, s2) < 0; }
};

template<class Value> class Hashtable {

    public:
    std::map<const char*, Value, ltstr> stMap;
    Hashtable* parent;

    Hashtable(Hashtable *p);

    bool defined(const char*);
    bool definedNotGlobal(const char*);
    bool localDefined(const char*);
    Value get(const char*);
    void insertFake(const char*);
    bool insert(const char*, Value);
    Hashtable* getGlobal();
};

#include "hashtable.cc" // icky, but allows implicit template instantiation

#endif
