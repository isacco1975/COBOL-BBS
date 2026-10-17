file_path = r"C:\My Storage\Vbox Share\COBOL BBS\igplogo.txt"

def generate_cobol_from_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Divide i due array usando '*' come separatore
    parts = content.split('*')
    if len(parts) < 2:
        raise ValueError("Il file non contiene il separatore '*'")
    
    # Pulisce e converte il primo array (caratteri)
    arr1_raw = parts[0].replace('\n', '').replace(' ', '').strip(',')
    array1 = [int(x) for x in arr1_raw.split(',') if x]
    
    # Pulisce e converte il secondo array (colori)
    arr2_raw = parts[1].replace('\n', '').replace(' ', '').strip(',')
    array2 = [int(x) for x in arr2_raw.split(',') if x]
    
    if len(array1) != len(array2):
        print(f"Attenzione: i due array hanno lunghezze diverse! Array 1: {len(array1)}, Array 2: {len(array2)}")
    
    # Ogni riga originale ha 19 elementi
    items_per_row = 19
    rows = []
    
    for i in range(0, len(array1), items_per_row):
        chunk1 = array1[i:i + items_per_row]
        chunk2 = array2[i:i + items_per_row]
        if not chunk1:
            break
        
        # Interleava carattere + colore e converte in esadecimale
        hex_row = ""
        for char_val, color_val in zip(chunk1, chunk2):
            hex_row += f"{char_val:02X}{color_val:02X}"
        
        rows.append(hex_row)
        
    # Genera la struttura COBOL per Acucobol con VALUE a capo
    cobol_lines = []
    cobol_lines.append("       01 WS-IGP-LOGO-TABLE.")
    
    for idx, hex_str in enumerate(rows, 1):
        row_num_str = f"{idx:02d}"
        cobol_lines.append(f"      *> --- RIGA {row_num_str} ---")
        
        part1 = hex_str[:38]
        part2 = hex_str[38:]
        
        # Parte 1 (con VALUE a capo)
        cobol_lines.append(f"          05 FILLER PIC X(19)")
        cobol_lines.append(f"             VALUE X'{part1}'.")
        
        # Parte 2 (con VALUE a capo)
        cobol_lines.append(f"          05 FILLER PIC X(19)")
        cobol_lines.append(f"             VALUE X'{part2}'.")
        
    # Aggiunge la redefinition comoda per l'uso nel programma
    cobol_lines.append("")
    cobol_lines.append("       01 WS-IGP-LOGO REDEFINES WS-IGP-LOGO-TABLE.")
    cobol_lines.append(f"          05 WS-LOGO-ROW OCCURS {len(rows)} TIMES.")
    cobol_lines.append("             10 WS-ROW-PART1 PIC X(19).")
    cobol_lines.append("             10 WS-ROW-PART2 PIC X(19).")
    
    return "\n".join(cobol_lines)

if __name__ == "__main__":
    try:
        cobol_output = generate_cobol_from_file(file_path)
        
        # Stampa il codice COBOL a schermo
        print(cobol_output)
        
        # Salva il codice COBOL generato in un file di testo
        output_path = r"C:\My Storage\Vbox Share\COBOL BBS\logo_acucobol.cbl"
        with open(output_path, 'w', encoding='utf-8') as out:
            out.write(cobol_output)
            print(f"\nCodice COBOL salvato con successo in: {output_path}")
            
    except FileNotFoundError:
        print(f"Errore: Il file '{file_path}' non è stato trovato.")
    except Exception as e:
        print(f"Errore imprevisto: {e}")
