file_path = r"C:\My Storage\Vbox Share\COBOL BBS\igplogo.txt"

def map_character(char_val):
    """Logica di conversione dei caratteri derivata dal codice .NET"""
    if 0 <= char_val <= 31:
        return char_val + 64
    elif 32 <= char_val <= 63:
        return char_val + 0
    elif 64 <= char_val <= 93:
        return char_val + 128
    elif char_val == 94:
        return 255
    elif char_val == 95:
        return char_val + 128
    elif 96 <= char_val <= 127:
        return char_val + 64
    elif 128 <= char_val <= 159:
        return char_val - 128
    elif 160 <= char_val <= 191:
        return char_val - 128
    elif 192 <= char_val <= 223:
        return char_val - 64
    elif 224 <= char_val <= 254:
        return char_val - 64
    else:
        return char_val

def map_petscii_color(color_val):
    """Tabella di conversione dei 16 colori C64 nei rispettivi codici PETSCII"""
    color_mapping = {
        0: 144,  # Nero ($90)
        1: 5,    # Bianco ($05)
        2: 28,   # Rosso ($1C)
        3: 159,  # Ciano ($9F)
        4: 156,  # Viola/Purpureo ($9C)
        5: 30,   # Verde ($1E)
        6: 31,   # Blu ($1F)
        7: 158,  # Giallo ($9E)
        8: 129,  # Arancione ($81)
        9: 149,  # Marrone ($95)
        10: 150, # Rosso chiaro ($96)
        11: 151, # Grigio scuro ($97)
        12: 152, # Grigio medio ($98)
        13: 153, # Verde chiaro ($99)
        14: 154, # Blu chiaro ($9A)
        15: 155  # Grigio chiaro ($9B)
    }
    return color_mapping.get(color_val, color_val)

def generate_cobol_from_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    parts = content.split('*')
    if len(parts) < 2:
        raise ValueError("Il file non contiene il separatore '*'")
    
    # Pulisce e converte il primo array (caratteri) applicando la regola .NET
    arr1_raw = parts[0].replace('\n', '').replace(' ', '').strip(',')
    array1 = [map_character(int(x)) for x in arr1_raw.split(',') if x]
    
    # Pulisce, converte e mappa il secondo array (colori)
    arr2_raw = parts[1].replace('\n', '').replace(' ', '').strip(',')
    array2 = [map_petscii_color(int(x)) for x in arr2_raw.split(',') if x]
    
    if len(array1) != len(array2):
        print(f"Attenzione: i due array hanno lunghezze diverse! Array 1: {len(array1)}, Array 2: {len(array2)}")
    
    items_per_row = 19
    rows = []
    
    for i in range(0, len(array1), items_per_row):
        chunk1 = array1[i:i + items_per_row]
        chunk2 = array2[i:i + items_per_row]
        if not chunk1:
            break
        
        hex_row = ""
        for char_val, color_val in zip(chunk1, chunk2):
            hex_row += f"{char_val:02X}{color_val:02X}"
        
        rows.append(hex_row)
        
    cobol_lines = []
    cobol_lines.append("       01 WS-IGP-LOGO-TABLE.")
    
    for idx, hex_str in enumerate(rows, 1):
        row_num_str = f"{idx:02d}"
        cobol_lines.append(f"      *> --- RIGA {row_num_str} ---")
        
        part1 = hex_str[:38]
        part2 = hex_str[38:]
        
        cobol_lines.append(f"          05 FILLER PIC X(19)")
        cobol_lines.append(f"             VALUE X'{part1}'.")
        
        cobol_lines.append(f"          05 FILLER PIC X(19)")
        cobol_lines.append(f"             VALUE X'{part2}'.")
        
    cobol_lines.append("")
    cobol_lines.append("       01 WS-IGP-LOGO REDEFINES WS-IGP-LOGO-TABLE.")
    cobol_lines.append(f"          05 WS-LOGO-ROW OCCURS {len(rows)} TIMES.")
    cobol_lines.append("             10 WS-ROW-PART1 PIC X(19).")
    cobol_lines.append("             10 WS-ROW-PART2 PIC X(19).")
    
    return "\n".join(cobol_lines)

if __name__ == "__main__":
    try:
        cobol_output = generate_cobol_from_file(file_path)
        print(cobol_output)
        
        output_path = r"C:\My Storage\Vbox Share\COBOL BBS\logo_acucobol.cbl"
        with open(output_path, 'w', encoding='utf-8') as out:
            out.write(cobol_output)
            print(f"\nCodice COBOL salvato con successo in: {output_path}")
            
    except FileNotFoundError:
        print(f"Errore: Il file '{file_path}' non è stato trovato.")
    except Exception as e:
        print(f"Errore imprevisto: {e}")