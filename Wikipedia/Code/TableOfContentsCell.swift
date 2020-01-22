import UIKit

// MARK: - Cell
class TableOfContentsCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var selectedSectionIndicator: UIView!
    @IBOutlet var indentationConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    
    var titleIndentationLevel: Int = 0 {
        didSet {
            titleLabelTopConstraint.constant = titleIndentationLevel == 0 ? 19 : 11;
            indentationConstraint.constant =  indentationWidth * CGFloat(1 + titleIndentationLevel)
        }
    }
    
    private var titleHTML: String = ""
    private var titleTextStyle: DynamicTextStyle = .georgiaTitle3
    func setTitleHTML(_ html: String, with textStyle: DynamicTextStyle, color: UIColor, selectionColor: UIColor) {
        titleHTML = html
        titleTextStyle = textStyle
        titleColor = color
        titleSelectionColor = selectionColor
    }
    
    func updateTitle() {
        let color = isTitleLabelHighlighted ? titleSelectionColor : titleColor
        titleLabel.attributedText = titleHTML.byAttributingHTML(with: titleTextStyle, matching: traitCollection, color: color)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTitle()
    }
    
    private var titleColor: UIColor = Theme.standard.colors.primaryText {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    private var titleSelectionColor: UIColor = Theme.standard.colors.link
    
    
    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        indentationWidth = 10
    }
    
    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        selectedSectionIndicator.alpha = 0.0
        selectionStyle = .none
    }
    
    // MARK: - Accessors
    
    func setSectionSelected(_ selected: Bool, animated: Bool) {
        if (selected) {
            setSelectionIndicatorVisible(titleIndentationLevel == 0)
        } else {
            setSelectionIndicatorVisible(false)
        }
    }
    
    // MARK: - UITableVIewCell

    class func reuseIdentifier() -> String{
        return wmf_nibName()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indentationLevel = 1
        setSectionSelected(false, animated: false)
        setSelected(false, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected){
            setTitleLabelHighlighted(true)
        } else {
            setTitleLabelHighlighted(false)
        }
    }
    
    private var isTitleLabelHighlighted: Bool = false
    func setTitleLabelHighlighted(_ highlighted: Bool) {
        isTitleLabelHighlighted = highlighted
        updateTitle()
    }
    
    func setSelectionIndicatorVisible(_ visible: Bool) {
        if (visible) {
            selectedSectionIndicator.backgroundColor = titleSelectionColor
            selectedSectionIndicator.alpha = 1.0
        } else {
            selectedSectionIndicator.alpha = 0.0

        }
    }
    
}
