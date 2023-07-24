import json

from deepdiff import DeepDiff


def main():
    pass
    print("main")
    origin_path = '/Users/steps/Workspace/html/moda/yivi/steps/irmamobile'
    toomore_path = '/Users/steps/Workspace/html/moda/yivi/toomore/privacybydesign.irmamobile'

    file = 'assets/locales/en.json'

    o_data = read_file(f"{origin_path}/{file}")
    t_data = read_file(f"{toomore_path}/{file}")


    # print(o_data)
    loop_print(o_data)


    # diff = DeepDiff(t_data, o_data)
    # check_add(diff, o_data)
    # check_remove(diff)
    # check_change(diff)




def loop_print(data):
    for key, value in data.items():
        if isinstance(value, dict):
            loop_print(value)
        else:
            with open("output.txt", 'a') as fp:
                fp.write(value)
                fp.write("\n")


def check_add(diff, meta):
    if 'dictionary_item_added' in diff:
        added_items = diff['dictionary_item_added']
        print(f"=== Add({len(added_items)}) ===")
        for item in added_items:
            print(f"新增的鍵：{item}")
            added_value = eval(f"meta{item[4:]}")
            print(f"新增的值：{added_value}")
            print('')

def check_remove(diff):
    if 'dictionary_item_removed' in diff:
        removeed_items = diff['dictionary_item_removed']
        print(f"=== Remove({len(removeed_items)}) ===")
        for item in removeed_items:
            print(f"刪除的key：{item}")
            print('')

def check_change(diff):
    if 'values_changed' in diff:
        change_items = diff['values_changed']
        print(f"=== Change({len(change_items)}) ===")
        for item, details in change_items.items():
            print(f"修改的key：{item}")

            old_value = details['old_value']
            new_value = details['new_value']
            print(f"舊值：{old_value}")
            print(f"新值：{new_value}")
            print('')

def read_file(filename):
    data = {}
    with open(filename, 'r') as fp:
        data = json.load(fp)
    return data


if __name__ == '__main__':
    main()
