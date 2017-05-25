/* File: hashtable.cc
 * ------------------
 * Implementation of Hashtable class.
 */

#include "hashtable.h"

template<class Value>
Hashtable<Value>::Hashtable(Hashtable *p) {
    parent = p;
}


template<class Value>
bool Hashtable<Value>::defined(const char* key) {
    Hashtable<Value>* current = this;
    if (current->localDefined(key)) {
        return true;
    }
    while (current->parent != 0) {
        current = current->parent;
        if (current->localDefined(key)) {
            return true;
        }
    }
    return false;
}

template<class Value>
bool Hashtable<Value>::definedNotGlobal(const char* key) {
    Hashtable<Value>* current = this;
    while (current->parent != 0) {
        if (current->localDefined(key)) {
            return true;
        }
        current = current->parent;
    }
    return false;
}

template<class Value>
bool Hashtable<Value>::localDefined(const char* key) {
    return stMap.count(key) == 1;
}


template<class Value>
Value Hashtable<Value>::get(const char* key) {
    Hashtable<Value>* current = this;
    if (current->localDefined(key)) {
        return stMap[key];
    }
    while (current->parent != 0) {
        current = current->parent;
        if (current->localDefined(key)) {
            return current->stMap[key];
        }
    }
    return NULL;
}


template<class Value>
void Hashtable<Value>::insertFake(const char* key) {
    stMap[key] = NULL;
}

template<class Value>
bool Hashtable<Value>::insert(const char* key, Value v) {
    bool inserted = stMap.insert(std::make_pair(key, v)).second; 
    return inserted;
}

template<class Value>
Hashtable<Value>* Hashtable<Value>::getGlobal() {
    Hashtable<Value>* current = this;
    while (current->parent != 0) {
        current = current->parent;
    }
    return current;
}
