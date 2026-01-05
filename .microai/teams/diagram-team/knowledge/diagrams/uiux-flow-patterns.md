# UI/UX Flow Patterns

Reference cho tạo user journey và screen flow diagrams.

---

## State Diagrams for UI

### Basic Navigation

```mermaid
stateDiagram-v2
    [*] --> Home

    Home --> Products
    Home --> Cart
    Home --> Profile

    Products --> ProductDetail
    ProductDetail --> Cart
    ProductDetail --> Products

    Cart --> Checkout
    Checkout --> OrderConfirmation
    OrderConfirmation --> [*]

    Profile --> Settings
    Profile --> Orders
    Profile --> [*]: Logout
```

### Authentication Flow

```mermaid
stateDiagram-v2
    [*] --> Login

    Login --> Dashboard: Success
    Login --> Login: Failed
    Login --> ForgotPassword
    Login --> Register

    ForgotPassword --> ResetPassword
    ResetPassword --> Login

    Register --> EmailVerification
    EmailVerification --> Dashboard

    Dashboard --> [*]: Logout
```

### Form States

```mermaid
stateDiagram-v2
    [*] --> Empty

    Empty --> Filling: User starts typing
    Filling --> Validating: Submit

    Validating --> Invalid: Errors found
    Validating --> Submitting: Valid

    Invalid --> Filling: User fixes
    Submitting --> Success: API success
    Submitting --> Error: API error

    Error --> Filling: Retry
    Success --> [*]
```

---

## Screen Navigation Flows

### E-Commerce App

```mermaid
flowchart LR
    subgraph Main
        Home --> Products
        Home --> Categories
        Home --> Search
    end

    subgraph Shopping
        Products --> ProductDetail
        ProductDetail --> Cart
        Cart --> Checkout
        Checkout --> Payment
        Payment --> OrderSuccess
    end

    subgraph Account
        Profile --> Orders
        Profile --> Settings
        Profile --> Wishlist
        Orders --> OrderDetail
    end

    Home --> Profile
```

### Mobile App Tabs

```mermaid
flowchart TD
    subgraph TabBar
        Tab1[Home]
        Tab2[Search]
        Tab3[Cart]
        Tab4[Profile]
    end

    subgraph Home
        Tab1 --> Feed
        Feed --> PostDetail
    end

    subgraph Search
        Tab2 --> SearchResults
        SearchResults --> ItemDetail
    end

    subgraph Cart
        Tab3 --> CartList
        CartList --> Checkout
    end

    subgraph Profile
        Tab4 --> Settings
        Tab4 --> History
    end
```

---

## User Journey Maps

### Onboarding Journey

```mermaid
stateDiagram-v2
    [*] --> Welcome

    state Welcome {
        [*] --> Slide1
        Slide1 --> Slide2
        Slide2 --> Slide3
    }

    Welcome --> SignUp: Get Started
    Welcome --> Login: Already have account

    state SignUp {
        [*] --> EnterEmail
        EnterEmail --> EnterPassword
        EnterPassword --> EnterProfile
    }

    SignUp --> EmailVerification
    EmailVerification --> Tutorial

    state Tutorial {
        [*] --> Step1
        Step1 --> Step2
        Step2 --> Step3
    }

    Tutorial --> Dashboard
    Login --> Dashboard
```

### Purchase Journey

```mermaid
flowchart TD
    A[Browse Products] --> B[View Product]
    B --> C{Add to Cart?}
    C -->|Yes| D[Add to Cart]
    C -->|No| A
    D --> E{Continue Shopping?}
    E -->|Yes| A
    E -->|No| F[View Cart]
    F --> G[Checkout]
    G --> H[Enter Shipping]
    H --> I[Select Payment]
    I --> J[Review Order]
    J --> K{Confirm?}
    K -->|Yes| L[Process Payment]
    K -->|No| F
    L --> M{Success?}
    M -->|Yes| N[Order Confirmation]
    M -->|No| O[Payment Error]
    O --> I
    N --> P[Email Receipt]
```

---

## Component States

### Button States

```mermaid
stateDiagram-v2
    [*] --> Default
    Default --> Hover: mouseenter
    Hover --> Default: mouseleave
    Hover --> Pressed: mousedown
    Pressed --> Hover: mouseup
    Default --> Focused: focus
    Focused --> Default: blur
    Default --> Disabled: disable()
    Disabled --> Default: enable()
    Default --> Loading: submit
    Loading --> Default: complete
```

### Modal States

```mermaid
stateDiagram-v2
    [*] --> Closed

    Closed --> Opening: trigger
    Opening --> Open: animation complete

    Open --> Closing: close action
    Closing --> Closed: animation complete

    state Open {
        [*] --> Content
        Content --> Confirming: submit
        Confirming --> Loading
        Loading --> Success
        Loading --> Error
        Error --> Content: retry
    }

    Success --> Closing
```

### Form Field States

```mermaid
stateDiagram-v2
    [*] --> Pristine

    Pristine --> Touched: user interacts
    Touched --> Valid: passes validation
    Touched --> Invalid: fails validation
    Valid --> Invalid: value changes
    Invalid --> Valid: value changes
    Invalid --> Touched: blur

    state Invalid {
        [*] --> ShowError
    }
```

---

## Error Handling UI

```mermaid
flowchart TD
    A[User Action] --> B{API Call}
    B -->|Success| C[Show Success]
    B -->|Error| D{Error Type}
    D -->|Network| E[Show Retry]
    D -->|Auth| F[Redirect Login]
    D -->|Validation| G[Show Field Errors]
    D -->|Server| H[Show Error Page]
    E -->|Retry| B
    G -->|Fix| A
```

---

## Responsive States

```mermaid
stateDiagram-v2
    [*] --> Desktop

    Desktop --> Tablet: resize < 1024px
    Tablet --> Desktop: resize >= 1024px
    Tablet --> Mobile: resize < 768px
    Mobile --> Tablet: resize >= 768px

    state Desktop {
        Sidebar
        MainContent
    }

    state Tablet {
        CollapsedSidebar
        MainContent
    }

    state Mobile {
        BottomNav
        FullWidthContent
    }
```

---

## Best Practices

1. **Start from user perspective** - What they see first
2. **Show happy path** - Main flow clearly
3. **Include error states** - How errors are shown
4. **Document transitions** - What triggers changes
5. **Use state diagrams** - For component states
6. **Use flowcharts** - For journeys
7. **Keep focused** - One journey per diagram
