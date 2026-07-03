from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
)


OUTPUT = "output/pdf/plan_pruebas_mi_app.pdf"


styles = getSampleStyleSheet()
styles.add(
    ParagraphStyle(
        name="TitleGreen",
        parent=styles["Title"],
        textColor=colors.HexColor("#1B5E20"),
        fontSize=22,
        leading=26,
        spaceAfter=14,
    )
)
styles.add(
    ParagraphStyle(
        name="Section",
        parent=styles["Heading2"],
        textColor=colors.HexColor("#2E7D32"),
        fontSize=14,
        leading=18,
        spaceBefore=10,
        spaceAfter=6,
    )
)
styles.add(
    ParagraphStyle(
        name="Body",
        parent=styles["BodyText"],
        fontSize=9.5,
        leading=13,
        spaceAfter=6,
    )
)
styles.add(
    ParagraphStyle(
        name="Small",
        parent=styles["BodyText"],
        fontSize=8,
        leading=10,
    )
)


def p(text, style="Body"):
    return Paragraph(text, styles[style])


def table(rows, widths):
    data = [[p(cell, "Small") for cell in row] for row in rows]
    t = Table(data, colWidths=widths, repeatRows=1)
    t.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#E8F5E9")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.HexColor("#1B5E20")),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("GRID", (0, 0), (-1, -1), 0.35, colors.HexColor("#C8D6C9")),
                ("VALIGN", (0, 0), (-1, -1), "TOP"),
                ("LEFTPADDING", (0, 0), (-1, -1), 6),
                ("RIGHTPADDING", (0, 0), (-1, -1), 6),
                ("TOPPADDING", (0, 0), (-1, -1), 5),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 5),
            ]
        )
    )
    return t


doc = SimpleDocTemplate(
    OUTPUT,
    pagesize=letter,
    rightMargin=0.55 * inch,
    leftMargin=0.55 * inch,
    topMargin=0.55 * inch,
    bottomMargin=0.55 * inch,
)

story = [
    p("Plan de pruebas - Mi App AgroCare", "TitleGreen"),
    p(
        "Este plan documenta las pruebas funcionales y de caja blanca propuestas para los modulos que no dependen de autenticacion. "
        "Las pruebas de login, registro y recuperacion de contrasena se excluyen temporalmente porque el flujo de autenticacion esta en correccion.",
    ),
    p("Alcance", "Section"),
    p(
        "Se cubren Dashboard, Mis Plantas, Historial, Biblioteca de enfermedades, Chat IA contextual, motor simulado de analisis y modelos de datos. "
        "No se reportan resultados de ejecucion; solo se define que pruebas se implementan y como ejecutarlas.",
    ),
    p("Pruebas de caja blanca implementadas", "Section"),
    table(
        [
            ["Archivo", "Objetivo", "Casos incluidos"],
            [
                "test/white_box/analysis_engine_test.dart",
                "Validar la logica interna del motor simulado.",
                "Hoja retorna Roya comun con 40%; Terreno conserva recomendaciones agronomicas.",
            ],
            [
                "test/white_box/ai_chat_service_test.dart",
                "Validar decisiones internas de respuesta del asistente.",
                "Estado con contexto de planta; tratamiento desde analisis; riego segun ultima fecha.",
            ],
            [
                "test/white_box/plant_dto_test.dart",
                "Validar conversion y reglas internas del DTO de planta.",
                "copyWith; toMap/fromMap; orden de historial de riegos; valores por defecto.",
            ],
            [
                "test/white_box/plants_manager_test.dart",
                "Validar comandos internos del administrador de plantas.",
                "Crear, actualizar, eliminar, registrar riego y refrescar lista observada.",
            ],
        ],
        [1.85 * inch, 2.15 * inch, 3.05 * inch],
    ),
    p("Pruebas de caja negra implementadas", "Section"),
    table(
        [
            ["Archivo", "Pantalla o modulo", "Comportamiento observado"],
            [
                "test/black_box/home_page_test.dart",
                "Dashboard principal",
                "Muestra resumen, acciones rapidas y navegacion inferior; permite abrir Mis Plantas.",
            ],
            [
                "test/black_box/history_page_test.dart",
                "Historial de analisis",
                "Muestra filtros, analisis registrado y modal de recomendaciones.",
            ],
            [
                "test/black_box/diseases_info_page_test.dart",
                "Biblioteca de enfermedades",
                "Lista enfermedades principales y despliega sintomas/tratamiento.",
            ],
            [
                "test/black_box/ai_chat_page_test.dart",
                "Chat IA",
                "Muestra selector, preguntas rapidas y respuesta al enviar una consulta.",
            ],
            [
                "test/black_box/app_routes_test.dart",
                "Rutas de aplicacion",
                "Verifica que las rutas apunten a las pantallas esperadas.",
            ],
            [
                "test/black_box/plant_form_page_test.dart",
                "Formulario de planta",
                "Verifica campos visibles y validaciones del registro de planta.",
            ],
        ],
        [1.9 * inch, 1.75 * inch, 3.4 * inch],
    ),
    p("Como ejecutar solo estas pruebas", "Section"),
    p(
        "Ejecutar las pruebas no relacionadas con autenticacion desde la raiz del proyecto:",
    ),
    p(
        "flutter test test/white_box/analysis_engine_test.dart test/white_box/ai_chat_service_test.dart "
        "test/white_box/plant_dto_test.dart test/white_box/plants_manager_test.dart "
        "test/black_box/home_page_test.dart test/black_box/history_page_test.dart "
        "test/black_box/diseases_info_page_test.dart test/black_box/ai_chat_page_test.dart "
        "test/black_box/app_routes_test.dart test/black_box/plant_form_page_test.dart",
    ),
    p(
        "Evitar temporalmente: test/white_box/firebase_auth_service_test.dart, test/white_box/auth_session_test.dart, "
        "test/black_box/login_page_test.dart y test/black_box/register_page_test.dart, hasta estabilizar autenticacion.",
    ),
    p("Criterios de aceptacion", "Section"),
    p(
        "Las pantallas deben renderizar sin bloqueo, las acciones principales deben exponer sus controles, los managers deben persistir cambios en fuentes simuladas, "
        "y el motor de analisis debe devolver la respuesta simulada acordada para Roya comun con 40% de afectacion.",
    ),
]

doc.build(story)
