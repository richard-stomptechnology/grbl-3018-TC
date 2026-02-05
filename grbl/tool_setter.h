#ifndef TOOL_SETTER_H
#define TOOL_SETTER_H

#include <stdbool.h>

// Persistent tool setter XY position
bool tool_setter_xy_is_set(void);
void tool_setter_get_xy(float *x, float *y);
void tool_setter_store_xy(float x, float y);

#endif // TOOL_SETTER_H
