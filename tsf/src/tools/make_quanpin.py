# Build a standalone 全拼 schema from luna_pinyin.schema.yaml + luna_quanpin.schema.yaml
import yaml, io, sys, copy, os

DATA = r"C:\Program Files\Rime\weasel-0.17.4\data"
base = yaml.safe_load(io.open(os.path.join(DATA, "luna_pinyin.schema.yaml"), encoding="utf-8"))
qp = yaml.safe_load(io.open(os.path.join(DATA, "luna_quanpin.schema.yaml"), encoding="utf-8"))

out = copy.deepcopy(base)
out.pop("__include", None)
out["schema"] = qp["schema"]
# speller: keep base rules, then apply the quanpin overrides (algebra __patch)
sp = copy.deepcopy(base.get("speller", {}))
sp.update(copy.deepcopy(qp.get("speller", {})))
out["speller"] = sp
# translator: base + prism override
tr = copy.deepcopy(base.get("translator", {}))
tr.update(copy.deepcopy(qp.get("translator", {})))
out["translator"] = tr

# keep useful top-level order
order = ["schema", "switches", "engine", "speller", "translator", "punctuator",
         "key_binder", "recognizer", "menu"]
ordered = {k: out[k] for k in order if k in out}
for k, v in out.items():
    if k not in ordered:
        ordered[k] = v

dst = sys.argv[1]
with io.open(dst, "w", encoding="utf-8", newline="\n") as f:
    f.write("# 全拼（由 luna_pinyin + luna_quanpin 合并成独立方案，避免方案列表里出现朙月拼音）\n")
    yaml.safe_dump(ordered, f, allow_unicode=True, sort_keys=False, default_flow_style=False)
print("written", dst, os.path.getsize(dst), "bytes")
print("keys:", list(ordered))
print("translator:", ordered.get("translator"))
