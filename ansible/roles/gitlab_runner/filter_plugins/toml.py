from ansible.errors import AnsibleFilterError, AnsibleRuntimeError
from ansible.module_utils._text import to_text
from ansible.module_utils.common._collections_compat import MutableMapping
from ansible.module_utils.six import string_types

from ansible.plugins.inventory.toml import toml_dumps

try:
    from ansible.plugins.inventory.toml import toml_loads
except ImportError:

    def toml_loads(v):
        raise AnsibleRuntimeError('The python "tomli" library is required.')


def from_toml(data):
    if not isinstance(data, string_types):
        raise AnsibleFilterError("from_toml requires a string, got %s" % type(data))
    return toml_loads(to_text(data, errors="surrogate_or_strict"))


def to_toml(data):
    if not isinstance(data, MutableMapping):
        raise AnsibleFilterError("to_toml requires a dict, got %s" % type(data))
    return to_text(toml_dumps(data), errors="surrogate_or_strict")


class FilterModule(object):
    def filters(self):
        return {"to_toml": to_toml, "from_toml": from_toml}
