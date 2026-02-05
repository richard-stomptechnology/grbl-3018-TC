#include "grbl.h"
#include <string.h>

#define EEPROM_ADDR_TOOL_SETTER_XY 900U
#define TOOL_SETTER_MAGIC 0xA5C3

typedef struct {
    float x, y;
    uint16_t magic;
} tool_setter_xy_t;

// Persistent: tool setter XY position in EEPROM
static void tool_setter_eeprom_write(const tool_setter_xy_t *pos) {
    memcpy_to_eeprom_with_checksum(EEPROM_ADDR_TOOL_SETTER_XY, (char*)pos, sizeof(tool_setter_xy_t));
}

static bool tool_setter_eeprom_read(tool_setter_xy_t *pos) {
    if (!memcpy_from_eeprom_with_checksum((char*)pos, EEPROM_ADDR_TOOL_SETTER_XY, sizeof(tool_setter_xy_t)))
        return false;
    return (pos->magic == TOOL_SETTER_MAGIC);
}

bool tool_setter_xy_is_set(void) {
    tool_setter_xy_t pos;
    return tool_setter_eeprom_read(&pos);
}

void tool_setter_get_xy(float *x, float *y) {
    tool_setter_xy_t pos;
    if (tool_setter_eeprom_read(&pos)) {
        if (x) *x = pos.x;
        if (y) *y = pos.y;
    } else {
        if (x) *x = 0.0f;
        if (y) *y = 0.0f;
    }
}

void tool_setter_store_xy(float x, float y) {
    tool_setter_xy_t pos = {x, y, TOOL_SETTER_MAGIC};
    tool_setter_eeprom_write(&pos);
}
